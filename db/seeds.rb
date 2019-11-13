tag_types = ['medication', 'medical_condition', 'test_imaging', 'treatments_and_procedures']

# Create root user
unless User.where(email: Rails.application.credentials.root_email).first
  puts 'Creating root user'
  user = User.new({
    email: Rails.application.credentials.root_email,
    password: Rails.application.credentials.root_password,
    first_name: 'Will',
    last_name: 'Haslett',
    phone_number: 1234567890,
    requires_phone_confirmation: false,
    role: 'root',
    onboarded: true
  })
  user.save!
end

# Create tag types
tag_types.each { |tag_name|
  unless TagType.where(label: tag_name).first
    puts 'Adding tag type: ' + tag_name
    tag = TagType.new({
      label: tag_name
    })
    tag.save
  end
}
