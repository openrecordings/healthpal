class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # NOTE: :otp_authenticatable was removed because it prevented a Rails update:
  #        devise-otp-rails5 was resolved to 0.2.4, which depends on rails (>= 3.2.6, < 5.1)
  #        If you need two-factor working again, you've got work to do.
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  has_many :recordings
  has_many :shares

  scope :regular, ->() { where role: 'user' }

  validates_presence_of :first_name
  validates_presence_of :last_name

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

  def can_access(recording)
    privileged? || accessible_users.include?(recording.user)
  end

  def accessible_users
    [self] + Share.shared_with_user(self).map {|s| s.user}
  end

  # devise-otp is disabled
        # Resets otp so that a new device is registered upon next login
        # def deprovision_otp
        #   set_otp_credentials
        #   self.otp_enabled = false
        #   self.otp_enabled_on = nil
        #   save!
        # end

        # # Disables otp
        # def disable_otp
        #   deprovision_otp
        #   self.update(otp_mandatory: false)
        # end

        # # Enables otp
        # def enable_otp
        #   set_otp_credentials
        #   save!
        # end

        # # Disables or enables 2FA based on current state
        # def toggle_otp
        #   if otp_mandatory
        #     disable_otp
        #   else
        #     enable_otp
        #   end
        # end

  # Disables or enables active state  based on current state
  # TODO: Implement record locking. If two admins hit this method for the same user at the
  # "same time", unexpected stuff could happen.
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

  private

  def set_otp_credentials
    self.otp_auth_secret = ROTP::Base32.random_base32
    self.otp_recovery_secret = ROTP::Base32.random_base32
    self.otp_persistence_seed = SecureRandom.hex
    self.otp_mandatory = true
  end

end
