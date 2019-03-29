class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  has_many :recordings
  has_many :shares

  scope :regular, ->() { where role: 'user' }

<<<<<<< HEAD
  validates_presence_of :first_name, :last_name, :phone_number, :email
=======
  validates_presence_of :first_name
  validates_presence_of :last_name
>>>>>>> dev

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
