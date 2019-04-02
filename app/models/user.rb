
class User < ApplicationRecord
  
  require 'twilio-ruby'
  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :timeoutable

  has_many :recordings
  has_many :shares

  scope :regular, ->() { where role: 'user' }

  validates_presence_of :first_name, :last_name, :email

  def send_sms_token
    new_phone_token = Array.new(4){rand(10)}.join
    self.update(phone_token: new_phone_token)
    client = Twilio::REST::Client.new(
      Rails.configuration.twilio_account_sid,
      Rails.configuration.twilio_auth_token)
    begin
      client.api.account.messages.create(
        from: Rails.configuration.twilio_from_phone_number,
        to: "+1#{phone_number}",
        body: new_phone_token
      )
    rescue => e
      logger.error ([e.message]+e.backtrace).join($/)
    end
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
  #   return if privileged?
  #   self.update! active: false if sign_in_count == 1
  end

  def full_name
    "#{first_name} #{last_name}"
  end

end
