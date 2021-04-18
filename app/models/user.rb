class User < ApplicationRecord
  
  require 'twilio-ruby'
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :timeoutable

  has_many :recordings
  has_many :shares
  has_many :visits, class_name: 'Ahoy::Visit'

  scope :regular, ->() { where role: 'user' }
  scope :visible, ->() { where.not hidden: true }

  before_validation :set_defaults

  validates_presence_of :first_name, :last_name, :email, if: :has_ever_logged_in

  def has_ever_logged_in
    sign_in_count > 0
  end

  def send_sms_token
    new_phone_token = Array.new(4){rand(10)}.join
    self.update(phone_token: new_phone_token)
    client = Twilio::REST::Client.new(
      Orals::Application.credentials.twilio[:account_sid],
      Orals::Application.credentials.twilio[:auth_token])
    begin
      client.api.account.messages.create(
        from: Orals::Application.credentials.twilio[:from_phone_number],
        to: "+1#{phone_number}",
        body: "Here is your HealthPAL access code: #{new_phone_token}"
      )
    rescue => e
      logger.error ([e.message]+e.backtrace).join($/)
    end
  end

	# https://github.com/plataformatec/devise#activejob-integration
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  # http://www.rubydoc.info/github/plataformatec/devise/Devise/Models/Authenticatable
  def active_for_authentication?
    super && active && (phone_confirmed_at || !requires_phone_confirmation)
  end

  def privileged?
    ['admin', 'root'].include?(role)
  end

  def root?
    role == root
  end

  def can_access(recording)
    privileged? || accessible_users.include?(recording.user)
  end

  def accessible_users
    [self] + Share.shared_with_user(self).map {|s| s.user}
  end

  def toggle_active
    self.update! active: !self.active
  end

  # Disables user login when appropriate. Called by Warden hook in config/initializers/devise.rb
  # TODO: Delete or create separate role for this
  def disable_after_first_session!
    # return if privileged?
    # self.update! active: false if sign_in_count == 1
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def name_and_email
    "#{first_name} #{last_name} (#{email})"
  end

  private

  def set_defaults
    self.role ||= 'user'
    self.timezone ||= 'America/New_York'
    self.requires_phone_confirmation = requires_phone_confirmation.nil? ? false : requires_phone_confirmation
    self.can_record = can_record.nil? ? true : can_record
    self.created_as_caregiver = created_as_caregiver.nil? ? false : created_as_caregiver
    self.onboarded = onboarded.nil? ? false : onboarded
    self.hidden = hidden.nil? ? false : hidden
  end

end
