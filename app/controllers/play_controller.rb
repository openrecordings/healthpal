class PlayController < ApplicationController

  def play
    # TODO: Pass in a recording ID
    @recording = Recording.last
  end

  def send_audio
    tmp_file = '/tmp/tmp.ogg'
    File.open(tmp_file, 'wb') { |file| file.write(Recording.last.audio) }
    send_file(tmp_file)
  end

end
