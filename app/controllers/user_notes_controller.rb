class UserNotesController < ApplicationController

  # TODO: CRUD methods only handle gem-specific JSON requests as of now. Handle exceptions.

  def new
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    puts 'new'
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
  end

  def create
    respond_with_bip(UserNote.create user_note_params)
  end

  def update
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    puts 'update'
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
  end

  def user_note_params
    params.require(:user_note).permit(:recording_id, :text)
  end

end
