class Org < ApplicationRecord
  has_many :users
  has_many :recordings, through: :users

  def regular_user_recordings
    recordings.select{|r| r.user.role == 'user'}
  end

	def regular_users
		self.org.users.regular
	end

end
