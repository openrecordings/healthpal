tag_types = ['Diagnosis', 'Discussion of medications', 'Education',
             'Follow-ups', 'Recommendation',
             'Signs, Symptoms and Problems',
             'Test and Imaging Results', 'Treatment Options']

# Create root user
unless User.where(email: Rails.application.config.root_email).first
  puts 'Creating root user'
  user = User.new({
    email: Rails.application.config.root_email,
    password: Rails.application.config.root_password,
    role: 'root'
  })
  user.save!
  user.disable_otp
end

# Create tag types
tag_types.each { |tagName|
  unless TagType.where(label: tagName).first
    puts 'Adding tag type: ' + tagName
    tag = TagType.new({
      label: tagName
    })
    tag.save
  end
}
