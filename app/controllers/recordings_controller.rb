class RecordingsController < ApplicationController
  before_action :only_admins

  def index
    @recordings = Recording.includes(:user)
  end
end
