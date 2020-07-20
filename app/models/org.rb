class Org < ApplicationRecord
  has_many :users
  has_many :recordings, through: :users
  has_many :visits, through: :users

  validates :name, presence: true, uniqueness: true
  
  def regular_user_recordings
    recordings.select{|r| r.user.role == 'user'}
  end

  def regular_user_visits
    visits.select{|v| v.user.role == 'user'}
  end

end
