Devise.setup do |config|
  config.mailer = 'DeviseMailer'
  config.mailer_sender = 'susan.m.tarczewski@dartmouth.edu'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 11
  config.reconfirmable = false
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.timeout_in = 180.minutes
  config.reset_password_within = 6.hours
  Warden::Manager.before_logout do |user, auth, opts|
    user.disable_after_first_session!
  end
end

Devise::Models::Invitable.module_eval do
  def invite3!(invited_by = nil, options = {})
    # This is an order-dependant assignment, this can't be moved
    was_invited = invited_to_sign_up?

    # Required to workaround confirmable model's confirmation_required? method
    # being implemented to check for non-nil value of confirmed_at
    if new_record_and_responds_to?(:confirmation_required?)
      def self.confirmation_required?; false; end
    end

    yield self if block_given?
    generate_invitation_token if no_token_present_or_skip_invitation?

    run_callbacks :invitation_created do
      self.invitation_created_at = Time.now.utc
      self.invitation_sent_at = self.invitation_created_at unless skip_invitation
      self.invited_by = invited_by if invited_by

      # Call these before_validate methods since we aren't validating on save
      self.downcase_keys if new_record_and_responds_to?(:downcase_keys)
      self.strip_whitespace if new_record_and_responds_to?(:strip_whitespace)

      if save(validate: false)
        self.invited_by.decrement_invitation_limit! if !was_invited and self.invited_by.present?
        deliver_invitation2(options) unless skip_invitation
      end
    end
  end

  def deliver_invitation2(options = {})
    generate_invitation_token! unless @raw_invitation_token
    self.update_attribute :invitation_sent_at, Time.now.utc unless self.invitation_sent_at    
  end
end

Devise::Models::Invitable::ClassMethods.module_eval do
  def invite2!(attributes = {}, invited_by = nil, options = {}, &block)
    attr_hash = ActiveSupport::HashWithIndifferentAccess.new(attributes.to_h)
    _invite2(attr_hash, invited_by, options, &block)
  end

  def _invite2(attributes = {}, invited_by = nil, options = {}, &block)
    invite_key_array = invite_key_fields
    attributes_hash = {}
    invite_key_array.each do |k,v|
      attribute = attributes.delete(k)
      attribute = attribute.to_s.strip if strip_whitespace_keys.include?(k)
      attributes_hash[k] = attribute
    end

    invitable = find_or_initialize_with_errors(invite_key_array, attributes_hash)
    invitable.assign_attributes(attributes)
    invitable.invited_by = invited_by
    unless invitable.password || invitable.encrypted_password.present?
      invitable.password = random_password
    end

    invitable.valid? if self.validate_on_invite
    if invitable.new_record?
      invitable.clear_errors_on_valid_keys if !self.validate_on_invite
    elsif invitable.invitation_taken? || !self.resend_invitation
      invite_key_array.each do |key|
        invitable.add_taken_error(key)
      end
    end

    yield invitable if block_given?
    invitable.invite3!(nil, options) if invitable.errors.empty?
    invitable
  end
end
