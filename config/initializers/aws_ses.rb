Aws::Rails.add_action_mailer_delivery_method(
  :ses,
  credentials: Aws::Credentials.new(
    Rails.application.credentials.aws[:access_key_id],
    Rails.application.credentials.aws[:secret_access_key]
  ),
  region: 'us-east-1'
)
