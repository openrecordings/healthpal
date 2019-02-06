desc 'Create Utterance records for usability transcripts'

task utterance_records: :environment do
  [Recording.find(1), Recording.find(2)].each do |r|
    r.json.each_with_index do |u, i|
      text = u['alternatives'][0]['transcript']

      first_word = u['alternatives'][0]['words'].first
      start_time = first_word['start_time']
      st = start_time['seconds'].to_f + start_time['nanos'] / 10**8

      last_word = u['alternatives'][0]['words'][1]
      end_time = last_word['end_time']
      et = end_time['seconds'].to_f + end_time['nanos'] / 10**8

      Utterance.create(
        index: (i + 1),
        begins_at: st,
        ends_at: et,
        text: text,
        recording_id: r.id
      )
    end
  end
end
