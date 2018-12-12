module BootstrapFlashHelper
  ALERT_TYPES = [:success, :info, :warning, :danger] unless const_defined?(:ALERT_TYPES)

  # Formats flash messages using bootstrap classes.
  def bootstrap_flash(options = {})
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless ALERT_TYPES.include?(type)

      tag_class = options.extract!(:class)[:class]
      tag_options = {
        class: "alert fade in alert-#{type} #{tag_class}"
      }.merge(options)

      close_button = content_tag(:button, raw("&times;"), type: "button", class: "close", "data-dismiss" => "alert")

      message_group = []
      Array(message).each do |msg|
        message_group << content_tag(:div, msg) if msg
      end
      # NOTE uniq is called because redundant error messages could occur. Redundant error
      # messages could occur because we have forms with multiple models being validated at once in this app
      flash_messages << content_tag(:div, close_button + message_group.uniq.join.html_safe, tag_options)
    end
    flash_messages.join("\n").html_safe
  end
end
