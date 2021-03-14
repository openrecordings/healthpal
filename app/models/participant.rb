class Participant < ApplicationRecord
  # Participant foreign keys are denormalized because every Participant belongs to and Org,
  # but only some Participants belong to a User
  belongs_to :org
  belongs_to :user, optional: true

  validates_uniqueness_of :redcap_id
end
