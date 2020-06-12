class Share < ApplicationRecord
  # A Share is an instance of someone authorizing another user to access their recordings. A share
  # can be revoked by setting :revoked_at. After revoking a Share, another Share record can be created
  # for the same user.
  belongs_to  :user

  validates_presence_of :shared_with_user_id

  # All active shares. Used by User#recordings_shared_with
  scope :active, ->() {where revoked_at: nil}

end
