# Represents a [User] press/click on an affordance in the app
#
# These are logged in two different ways, as HTTP requests that are captured in [ApplicationController],
# and as AJAX POSTs from certain elements for which we are logging clicks on the client
# Both [User] and [Recording] are optional, depending on the context of the click
class Click < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :recording, optional: true
end
