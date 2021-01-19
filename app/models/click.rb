class Click < ApplicationRecord
  # Both user and recording are optional. No user when not logged in, and no recording in many cases
  belongs_to :user
  belongs_to :recording
end
