class PlayController < ApplicationController
  # TODO: Handle non-user roles
  #       Handle non-existant recording ids
  #       Handle non-existant media files
  # NOTE: This vesrion does not include code needed to set up annotations and links for the UI.
  #       That code is in the hp_r01 branch and needs to be migrated to here if annotations and
  #       links are to be used.
  # Has two forms, with and without an intial recording ID on page load:
  #   - HTML request without a recording ID: /my_recordings (@recording will be nil)
  #   - HTML request with a recording ID: /my_recordings/45
  def index
    @recording = Recording.find_by(id: params[:id])
    @recordings = current_user.viewable_recordings
    @recordings_by_user = current_user.viewable_recordings_by_user
  end

end
