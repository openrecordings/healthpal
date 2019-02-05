desc 'Create Utterance records for usability transcripts'

task utterance_records: :environment do
  [Recording.find(1), Recording.find(2)].each do |r|
    json = r.json
    puts json
  end
end
