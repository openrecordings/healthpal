class UserNote < ApplicationRecord

  # This class is implemented as an application-wide utility for user-entered notes. As of now, it
  # is only being used in association with a Recording. Add associtions for other models that will
  # have notes.

  belongs_to :recording

  # validates_presence_of :recording
    
end
