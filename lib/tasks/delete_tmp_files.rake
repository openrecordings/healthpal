desc 'Delete all files from the recordings_tmp folder '
task delete_tmp_audio: :environment do
  FileUtils.rm_rf(Dir.glob "#{Rails.root}/recordings_tmp/*")
end
