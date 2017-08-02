class HomeController < ApplicationController

  def index
    redirect_to :admin if current_user.privileged?
  end

  def play
    # TODO: Pass in a recording ID
  end

  def send_audio
    tmp_file = '/tmp/tmp.ogg'
    File.open(tmp_file, 'wb') { |file| file.write(Recording.last.audio) }
    send_file(tmp_file)
  end

end
