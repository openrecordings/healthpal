class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :otp_authenticatable, :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :recordings

  scope :regular, ->() { where role: 'user' }

  # 2FA is disabled
  # before_create :set_otp_credentials

  # http://www.rubydoc.info/github/plataformatec/devise/Devise/Models/Authenticatable
  def active_for_authentication?
    super && active
  end

  def privileged?
    ['admin', 'root'].include?(role)
  end

  def root?
    role == root
  end

  # Resets otp so that a new device is registered upon next login
  def deprovision_otp
    set_otp_credentials
    self.otp_enabled = false
    self.otp_enabled_on = nil
    save!
  end

  # Disables otp
  def disable_otp
    deprovision_otp
    self.update(otp_mandatory: false)
  end

  # Enables otp
  def enable_otp
    set_otp_credentials
    save!
  end

  # Disables or enables 2FA based on current state
  def toggle_otp
    if otp_mandatory
      disable_otp
    else
      enable_otp
    end
  end

  private

  def set_otp_credentials
    self.otp_auth_secret = ROTP::Base32.random_base32
    self.otp_recovery_secret = ROTP::Base32.random_base32
    self.otp_persistence_seed = SecureRandom.hex
    self.otp_mandatory = true
  end

end
