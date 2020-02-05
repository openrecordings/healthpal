class Message < ApplicationRecord

  belongs_to :user
  belongs_to :message_template

end
