class RecordingsController < ApplicationController
  def recordings
    @rc = Recording.order("created_at asc")
  end
end
