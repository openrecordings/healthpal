module ApplicationHelper

  def app_display_name
    Rails.application.config.app_display_name ? Rails.application.config.app_display_name : 'Open Recordings'
  end

  # Example: Mon, 09 Nov 2009 00:00:00 +0000 => 11/09/09 12:00 AM
  def format_date_time(date_time)
    date_time.strftime('%m/%d/%y %I:%M %p') if date_time
  end

  def mm_ss(seconds)
    mm = (seconds / 60).floor
    ss = "%02d" % (seconds % 60).to_i
    "#{mm}:#{ss}"
  end

end
