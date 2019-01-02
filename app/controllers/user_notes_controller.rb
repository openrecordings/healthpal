class UserNotesController < ApplicationController
  
  def update
    # TODO: Error handling
    @user_note = UserNote.find params[:id]
    @user_note.update user_note_params
    respond_with_bip @user_note
  end

  def user_note_params
    params.require(:user_note).permit(:recording_id, :text)
  end

end
