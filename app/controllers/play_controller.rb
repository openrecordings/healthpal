class PlayController < ApplicationController

  layout 'player', only: :play  

  def index
    # TODO: Handle bad data
    # TODO: Ultimately, we might want to restrict admin users again
    if current_user.privileged?
      @users = User.joins(:recordings).order(:email).uniq
    else
      # All users who are currently sharing with current_user
      @users = [current_user] + Share.shared_with_user(current_user).map {|s| s.user}.
        sort_by {|s| s.last_name}
    end
  end

  def play
    # TODO: Get hard-coded links out of the code
    @links = links
    if (@recording = Recording.find_by(id: params[:id]))
      unless current_user.can_access(@recording)
        flash.alert = 'You do not have permission to play that recording'
        redirect_to :root and return
      end
    else
      flash.alert = 'Could not find that recording'
      redirect_to :root and return
    end

    # Collapse consecutive utterances with identical tags, adjusting start-end times to cover all
    @tags = ((@recording.tags.group_by(&:utterance).inject([]) {
      |x, y| (x.empty? || (get_tags(x[-1]) != get_tags(y))) ?
        x << y :
        x[0..-2] << combine_utterances(x[-1], y)
    }).sort_by {|x| x[0].index})
  end

  def send_audio
    if (recording  = Recording.find_by(id: params[:id]))
      ##################################################################################
      # TODO Re-enable the commented-out condictional authorizing playback when the 
      #      caregiver data model is done.
      ##################################################################################
      #if recording.user == current_user || current_user.privileged?
        tmp_file = "#{Rails.root}/recordings_tmp/#{recording.id}.ogg"
        File.open(tmp_file, 'wb') { |file| file.write(recording.audio) }
        response.header['Accept-Ranges'] = 'bytes'
        response.headers['Content-Length'] = File.size tmp_file
        send_file(tmp_file)
      # else
      #   # User does not own recording and is not privileged
      #   return nil
      # end
      ##################################################################################
    else
      # Could not find recording with given id
      return nil
    end
  end

  private

  # Get the sorted list of tags for this utterance entry
  def get_tags(utterance)
    utterance[1].map(&:tag_type).sort
  end

  # Reduce two identically tagged utterance entries into a single entry which spans both of them.
  def combine_utterances(utt1, utt2)
    [Utterance.new({begins_at: utt1[0].begins_at,
                    ends_at: utt2[0].ends_at,
                    index: utt1[0].index,
                    id: utt1[0].id}), utt2[1]]
  end
  
  def links
    [[
    '0:09',
    'Norco ',
    'https://medlineplus.gov/druginfo/meds/a601006.html',
    4222
    ],[
    '0:14',
    'Gabapentin',
    'https://medlineplus.gov/druginfo/meds/a694007.html',
    4222
    ],[
    '0:17',
    'Tramadol',
    'https://medlineplus.gov/druginfo/meds/a695011.html',
    4222
    ],[
    '0:27',
    'high blood pressure',
    'https://medlineplus.gov/highbloodpressure.html',
    4229
    ],[
    '1:41',
    'Gabapentin',
    'https://medlineplus.gov/druginfo/meds/a694007.html',
    4252
    ],[
    '1:41',
    'shingles',
    'https://medlineplus.gov/shingles.html',
    4252
    ],[
    '1:54',
    'Gabapentin',
    'https://medlineplus.gov/druginfo/meds/a694007.html',
    ],[
    '1:41',
    'Gabapentin',
    'https://medlineplus.gov/druginfo/meds/a694007.html',
    ],[
    '2:04',
    'Gabapentin',
    'https://medlineplus.gov/druginfo/meds/a694007.html',
    4257
    ],[
    '2:29',
    'Gabapentin',
    'https://medlineplus.gov/druginfo/meds/a694007.html',
    4262
    ],[
    '2:40',
    'Gabapentin',
    'https://medlineplus.gov/druginfo/meds/a694007.html',
    4266
    ],[
    '3:00',
    'foot pain',
    'https://medlineplus.gov/ency/article/003183.htm',
    4270
    ],[
    '3:22',
    'bunion',
    'https://medlineplus.gov/ency/article/001231.htm',
    4270
    ],[
    '3:26',
    'arthritis',
    'https://medlineplus.gov/arthritis.html',
    4270
    ],[
    '3:44',
    'arthritis',
    'https://medlineplus.gov/arthritis.html',
    4282
    ],[
    '4:03',
    'ganglion cyst',
    'https://www.assh.org/handcare/hand-arm-conditions/ganglion-cyst',
    4290
    ],[
    '5:20',
    'ganglion cyst',
    'https://www.assh.org/handcare/hand-arm-conditions/ganglion-cyst',
    4317
    ],[
    '5:59',
    'ganglion cyst',
    'https://www.assh.org/handcare/hand-arm-conditions/ganglion-cyst',
    4330
    ],[
    '6:57',
    'blood count test',
    'https://medlineplus.gov/bloodcounttests.html',
    4346
    ],[
    '7:14',
    'pain management',
    'http://www.asahq.org/whensecondscount/pain-management/',
    4360
    ],[
    '7:30',
    'pain management',
    'http://www.asahq.org/whensecondscount/pain-management/',
    4364
    ],[
    '10:11',
    'blood pressure measurement',
    'https://medlineplus.gov/ency/article/007490.htm',
    4410
    ]]
  end

  



end
