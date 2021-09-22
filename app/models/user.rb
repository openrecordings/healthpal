class User < ApplicationRecord
  require 'twilio-ruby'
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :timeoutable

  belongs_to :org, optional: true
  has_one :participant
  has_many :recordings
  has_many :shares
  has_many :visits, class_name: 'Ahoy::Visit'
  has_many :clicks

  attr_reader :raw_invitation_token

  scope :regular, -> { where role: 'user' }

  before_validation :set_defaults

  validates :onboarded, :active, :requires_phone_confirmation, :created_as_caregiver,
            inclusion: [true, false]
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

  def corrected_sign_ins
    return 0 if sign_in_count.zero?

    created_as_caregiver ? sign_in_count : sign_in_count - 1
  end

  def viewable_visits
    viewable = visits
    viewable += org.regular_user_visits if admin?
    viewable += Ahoy::Visit.all if root?
    viewable.flatten.uniq
  end

  def viewable_recordings
    viewable = recordings
    viewable += recordings_shared_with
    viewable += org.recordings if admin?
    viewable += Recording.all if root?
    viewable.flatten.uniq.sort_by(&:created_at).reverse
  end

  def viewable_recordings_by_user
    recordings = viewable_recordings
    return [] unless recordings.any?

    recordings_by_user = []
    users = recordings.map { |r| r.user }.uniq
    if users.select { |u| !u.last_name.nil? }.length == users.length
      users = users.sort_by { |u| u.last_name.downcase }
    end
    users.each do |user|
      user_recordings = {
        user: user,
        recordings: recordings.select { |r| r.user == user }
      }
      if user == self
        recordings_by_user.insert(0, user_recordings)
      else
        recordings_by_user << user_recordings
      end
    end
    recordings_by_user
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

  def total_clicks_on_play
    clicks.where(element_id: 'play-pause-button').count
  end

  # NOTE: `active` is necessary or Share revocation doesn't work
  def recordings_shared_with
    Share.active.where(shared_with_user_id: id).map { |s| s.user.recordings }
  end

  def has_ever_logged_in
    sign_in_count > 0
  end

  def send_sms(sms_text)
    client = Twilio::REST::Client.new(
      Orals::Application.credentials.twilio[:account_sid],
      Orals::Application.credentials.twilio[:auth_token]
    )
    begin
      client.api.account.messages.create(
        from: Orals::Application.credentials.twilio[:from_phone_number],
        to: "+1#{phone_number}",
        body: sms_text
      )
    rescue StandardError => e
      logger.error ([e.message] + e.backtrace).join($/)
    end
  end

  def send_sms_test(invite_url)
    puts("SEND SMS TEXT!!!!!: #{invite_url}")
    sms_text = "#{I18n.t(:share_invite_sms)} #{invite_url}"
    send_sms(sms_text)
  end

  def send_sms_token
    new_phone_token = Array.new(6) { rand(10) }.join
    sms_text = "#{I18n.t(:share_invite_sms)} #{new_phone_token}"
    self.phone_token = phone_token
    update(phone_token: new_phone_token)
    send_sms(sms_text)
  end

  def reminder_1_text
    "#{I18n.t(:hi)} #{first_name},\n\n#{I18n.t(:reminder_sms_1a)} #{org&.contact_email_address}\n\n#{I18n.t(:reminder_sms_1b)}"
  end

  def reminder_2_text
    "#{I18n.t(:hi)} #{first_name},\n\n#{I18n.t(:reminder_sms_2a)} #{org&.contact_email_address}\n\n#{I18n.t(:reminder_sms_2b)}"
  end

  def reminder_3_text
    "#{I18n.t(:hi)} #{first_name},\n\n#{I18n.t(:reminder_sms_3a)} #{org&.contact_email_address}\n\n#{I18n.t(:reminder_sms_3b)}"
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
    update! active: !active
  end

  def toggle_can_record
    update! can_record: !can_record
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
