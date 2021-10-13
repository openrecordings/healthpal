class PlayController < ApplicationController
  # A reminder for parsing (some generation of) transcript JSON from AWS
  # json.first['alternatives'].first['words'].first['start_time']['seconds']

  # TODO: Handle non-user roles
  #       Handle non-existant recording ids
  #       Handle non-existant media files
  # Has two forms, with and without an intial recording ID on page load:
  #   - HTML request without a recording ID: /my_recordings (@recording will be nil)
  #   - HTML request with a recording ID: /my_recordings/45
  def index
    @recording = Recording.find_by(id: params[:id])
    @recordings = current_user.viewable_recordings
    @recordings_by_user = current_user.viewable_recordings_by_user_date
  end

  private

  # NOTE: Disabled because tag table is currently disabled
  # Merges contiguous utterances that have the same tag(s)
  # def prepare_utterances(recording)
  #   return_utterances = []
  #   multi_utterance = nil
  #   utterances = recording.utterances.order(:index)
  #   utterances.each do |utterance|
  #     if utterance.tags.any?
  #       utterance.tmp_tag_types = utterance.tag_types
  #       multi_utterance = utterance if multi_utterance.nil?
  #       if utterance.tmp_tag_types == multi_utterance.tmp_tag_types
  #         multi_utterance.text += " #{utterance.text}"
  #         multi_utterance.ends_at = utterance.ends_at
  #         multi_utterance.links += utterance.links
  #       else
  #         return_utterances << multi_utterance unless multi_utterance.nil?
  #         multi_utterance = utterance
  #       end
  #       puts return_utterances.map{|u| u.id}
  #     end
  #   end
  #   return_utterances << multi_utterance unless multi_utterance.nil?
  #   return_utterances
  # end

end
