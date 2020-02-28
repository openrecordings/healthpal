

# Create seeded users
def create_user(user_yaml)
  unless User.where(email: Rails.application.credentials.root_email).first
    puts "Creating user for #{user_yaml[:email]} with role #{user_yaml[:role]}"
    user = User.create!(user_yaml)
  end
end
Rails.application.credentials.seeded_users.each{|u| create_user(u)}

# Create tag types
tag_types = ['medication', 'medical_condition', 'tests_and_imaging', 'treatments_and_procedures']
tag_types.each { |tag_name|
  unless TagType.where(label: tag_name).first
    puts 'Adding tag type: ' + tag_name
    tag = TagType.new({
      label: tag_name
    })
    tag.save
  end
}

# Create message templates
MessageTemplate.create(
  subject: 'Your audio recording is ready',
  trigger: :after_processing
) 
MessageTemplate.create(
  trigger: :time_after_recording,
  offset_duration: 1.week
) 
MessageTemplate.create(
  subject: 'Your next recorded visit is coming up',
  trigger: :pre_followup,
  offset_duration: 3.days
) 
