# Create root user
unless User.where(email: Rails.application.config.root_admin_user_name).first
  User.new({
    email: Rails.application.config.root_email,
    password: Rails.application.config.root_admin_user_password,
    role: 'root'
  }).save
