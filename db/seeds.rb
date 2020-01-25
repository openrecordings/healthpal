

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
  text: "Hello. Thank you again for participating in the AUDIO Trial. Your clinic visit recording is now available. Click on this link to be taken to it https://audiohealthpal.com.  Please listen to your recording - it will help you remember important information from your visit. You may want to listen to: Changes to your treatment, advice from your doctor and things you have to do, things you told your doctor and things you may have forgot to mention. You may also want to share your recording with a family member to keep them up to date with your care or so they can help with the care you receive. Please do not hesitate to contact us with any questions.",
  trigger: :after_processing
) 
MessageTemplate.create(
  text: "Hello. This is a reminder that your clinic visit recording from last week is available. Click on this link to be taken to it: https://audiohealthpal.com. Please listen to your recording - it will help you remember important information from your visit. You may want to listen to changes to your treatment, advice from your doctor and things you have to do, things you told your doctori, and things you may have forgot to mention. You may also want to share your recording with a family member to keep them up to date with your care or so they can help with the care you receive. If you do not remember how to log in you can click on the “Forgot password” link to create a new password. You can also contact us with any questions",
  trigger: :time_after_recording,
  offset_duration: 1.week
) 
MessageTemplate.create(
  text: "Hello. You may want to listen to your clinic visit recording before your upcoming office visit. Click on this link to be taken to it https://audiohealthpal.com. By listening to your recording you may identify the information from your last visit that you want to ask the doctor, clarify your goals you would like to talk about with the doctor. If you do not remember how to log in you can click on the “Forgot password” link to create a new password. You can also contact us with any questions",
  trigger: :pre_followup,
  offset_duration: 3.days
) 
