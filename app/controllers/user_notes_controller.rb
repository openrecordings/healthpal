class UserNotesController < ApplicationController


  def create
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    puts 'create'
    puts params
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

    # TODO finish this method
    UserNote.create user_note_params
  end

  def update
    # TODO: This method only handles gem-specific JSON requests as of now. Handle exceptions.
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    puts 'update'
    puts params
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'

    respond_with_bip(UserNote.update user_note_params)

  end

  def user_note_params
    params.require(:user_note).permit(:recording_id, :text)
  end

end
