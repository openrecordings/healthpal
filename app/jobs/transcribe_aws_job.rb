class TranscribeAwsJob < ApplicationJob
  queue_as :default

  def perform(recording)
    # Do something later
  end
end
