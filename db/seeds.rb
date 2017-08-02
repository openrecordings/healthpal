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
