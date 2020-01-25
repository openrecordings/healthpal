class MessageTemplate < ApplicationRecord

  attribute :offset_duration, :duration

  enum trigger: [:after_processing, :time_after_recording, :pre_followup]

end
