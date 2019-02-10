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
  has_many :user_fields

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
