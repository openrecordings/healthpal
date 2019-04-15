desc 'Create Utterance records from a Google transcription'
task utterances_from_gcp: :environment do

  # Hard-coded recording ID for now
  recording_id = 11

  recording = Recording.find(recording_id)
	recording.json.each_with_index do |utterance_hash, i|
    puts utterance_hash
    Utterance.create!(
      index: i,
      begins_at: start_time(utterance_hash),
      ends_at: end_time(utterance_hash),
      text: text(utterance_hash),
      recording_id: recording.id
    )
  end

end

def start_time(utterance_hash)
	first_word = utterance_hash['alternatives'][0]['words'].first
	start_time = first_word['start_time']
	start_time['seconds'].to_f + start_time['nanos'] / 10**8
end

def end_time(utterance_hash)
  last_word = utterance_hash['alternatives'][0]['words'].last
  end_time = last_word['end_time']
  end_time['seconds'].to_f + end_time['nanos'] / 10**8
end

def text(utterance_hash)
	utterance_hash['alternatives'][0]['transcript']
end
