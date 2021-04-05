class ProcessRecordingJob < ApplicationJob
  queue_as :recording_processing
  def perform(recording)
    recording.transcode
    recording.reload.transcribe
    recording.reload.annotate
    recording.reload.update is_processed: true
    recording.create_ready_email
  end
end
