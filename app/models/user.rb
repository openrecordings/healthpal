class User < ApplicationRecord

  require 'twilio-ruby'
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :timeoutable

  belongs_to :org, optional: true
  has_many :recordings
  has_many :shares
  has_many :visits, class_name: 'Ahoy::Visit'

  scope :regular, ->() { where role: 'user' }

  before_validation :set_defaults

  validates :onboarded, :active, :requires_phone_confirmation, inclusion: [true, false] 
  validates_presence_of :email, :role, :timezone
  validates_presence_of :first_name, :last_name, if: :has_ever_logged_in
  validates_presence_of :org, unless: :root?

  def admin?
    role == 'admin'
  end

  def root?
    role == 'root'
  end

  def privileged?
    admin? || root?
  end

  def viewable_visits
    viewable = visits
    viewable += org.regular_user_visits if admin?
    viewable += Ahoy::Visit.all if root?
    viewable.flatten.uniq
  end

  # TODO: This needs to sort by recording owner, then by reverse chron to support
  #       users who are both caregivers and have their own recordings
  def viewable_recordings
    viewable = recordings
    viewable += recordings_shared_with
    viewable += org.regular_user_recordings if admin?
    viewable += Recording.all if root?
    viewable.flatten.uniq.sort_by(&:created_at).reverse
  end

  def viewable_users
    case role
    when 'user'
      [self]
    when 'admin'
      [self] + org.users.regular
    when 'root'
      User.all.to_a
    end
  end

  # NOTE: `active` is necessary or Share revocation doesn't work
  def recordings_shared_with
    Share.active.where(shared_with_user_id: self.id).map{|s| s.user.recordings}
  end

  def has_ever_logged_in
    sign_in_count > 0
  end

  def send_sms_token
    new_phone_token = Array.new(6){rand(10)}.join
    self.phone_token = phone_token
    self.update(phone_token: new_phone_token)
    client = Twilio::REST::Client.new(
      Orals::Application.credentials.twilio[:account_sid],
      Orals::Application.credentials.twilio[:auth_token])
    begin
      client.api.account.messages.create(
        from: Orals::Application.credentials.twilio[:from_phone_number],
        to: "+1#{phone_number}",
        body: "This is your HealthPAL confirmation code: #{new_phone_token}"
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

  def can_access(recording)
    viewable_recordings.include?(recording)
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
    self.onboarded = onboarded.nil? ? false : onboarded
    self.requires_phone_confirmation = requires_phone_confirmation.nil? ? false : requires_phone_confirmation
  end

end
