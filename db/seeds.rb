tag_types = ['Medication', 'Medical condition', 'Test & Imaging', 'Treatments & Procedures']

# Create root user
unless User.where(email: Rails.application.config.root_email).first
  puts 'Creating root user'
  user = User.new({
    email: Rails.application.config.root_email,
    password: Rails.application.config.root_password,
    first_name: 'Will',
    last_name: 'Haslett',
    phone_number: 1234567890,
    requires_phone_confirmation: false,
    role: 'root'
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
