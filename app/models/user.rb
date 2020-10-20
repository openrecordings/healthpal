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

  validates :onboarded, :active, :requires_phone_confirmation, :created_as_caregiver, inclusion: [true, false] 
  validates_presence_of :email, :role, :timezone
  validates_presence_of :org, unless: :root?
  validates_presence_of :phone_number, if: :requires_phone_confirmation

  def admin?
    role == 'admin'
  end

  def root?
    role == 'root'
  end

  def privileged?
    admin? || root?
  end

  def caregiver?
    created_as_caregiver
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
    viewable += org.recordings if admin?
    viewable += Recording.all if root?
    viewable.flatten.uniq.sort_by(&:created_at).reverse
  end

  def viewable_users
    case role
    when 'user'
      [self]
    when 'admin'
      [self] + org.users
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
    sms_text = 'Hello! a family member or friend (or patient first name) would like to share '\
      'with you an audio recording of their recent doctor’s visit that they want you to '\
      "hear. \n\n You will receive an email with a special link to audiohealthpal.com. "\
      'When you click on that link, enter this code to confirm your identity and set up '\
    "your account: #{new_phone_token}"
    self.phone_token = phone_token
    self.update(phone_token: new_phone_token)
    client = Twilio::REST::Client.new(
      Orals::Application.credentials.twilio[:account_sid],
      Orals::Application.credentials.twilio[:auth_token])
    begin
      client.api.account.messages.create(
        from: Orals::Application.credentials.twilio[:from_phone_number],
        to: "+1#{phone_number}",
        body: sms_text
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

  def toggle_can_record
    self.update! can_record: !self.can_record
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
  end

end
