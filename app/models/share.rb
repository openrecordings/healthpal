class Share < ApplicationRecord
  # A Share is an instance of someone authorizing another user to access their recordings. A share
  # can be revoked by steeing :revoked_at to anything but nil. After revoking a Share, another Share record can be created
  # for the same user.
  belongs_to :user

  scope :active, ->() {where revoked_at: nil}
  
end
