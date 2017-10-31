class RecordingsController < ApplicationController
  def index
    @recordings = Recording.includes(:user)
  end
end
