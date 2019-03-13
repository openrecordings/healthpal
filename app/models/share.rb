class Share < ApplicationRecord
  # A Share is an instance of someone authorizing another user to access their recordings. A share
  # can be revoked by steeing :revoked_at. After revoking a Share, another Share record can be created
  # for the same user.
  belongs_to  :user

  validates_presence_of :shared_with_user_id

  # All active shares
  scope :active, ->() {where revoked_at: nil}
  # All shares where the passed-in user is the share-ee
  scope :shared_with_user, ->(u) {active.where(shared_with_user_id: u.id)}

  # Returns the shared-with User
  def shared_with
    User.find_by(id: self.shared_with_user_id)
  end
  
end
