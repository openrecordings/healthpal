module ApplicationHelper

  # Returns the configured app name or a default
  def app_display_name
    Orals::Application.credentials.app_display_name || 'Open Recordings'
  end

  # Example: Mon, 09 Nov 2009 00:00:00 +0000 => 11/9/9 12:00 AM
  def format_date(date_time)
    date_time.strftime('%-m/%-d/%Y') if date_time
  end
  # Example: Mon, 09 Nov 2009 00:00:00 +0000 => 11/09/09
  def format_date_leading(date_time)
    date_time.strftime('%m/%d/%Y') if date_time
  end

  # Example: Mon, 09 Nov 2009 00:00:00 +0000 => 11/09/09 12:00 AM
  def format_date_time(date_time)
    date_time.strftime('%m/%d/%y %I:%M %p').downcase if date_time
  end
  # Example: Mon, 09 Nov 2009 00:00:00 +0000 => 11/09/09 12:00 AM
  def format_date_time_sec(date_time)
    date_time.strftime('%m/%d/%y %I:%M:%S.%L %p') if date_time
  end

  # Example: Mon, 09 Nov 2009 00:00:00 +0000 => 11/09/09 12:00 AM
  def format_date_time_sort(date_time)
    date_time.strftime('%Y/%m/%d %I:%M %p') if date_time
  end

  # Example: Mon, 09 Nov 2009 00:00:00 +0000 => Nov 09, 2009
  def format_date_time_long(date_time)
    date_time.strftime("%a, %b %-d, %Y") if date_time
  end

  # Example: Mon, 09 Nov 2009 00:00:00 +0000 => Nov 09, 2009 - 12:00AM
  def format_date_time_friendly(date_time)
    date_time.strftime("%a %b %-d, %Y, %I:%M %p") if date_time
  end

  # Example: Mar 13 
  def minimal_date(date_time)
    date_time.strftime("%b %-d") if date_time
  end

  # Returns a [String] representing how many days in the past the passed-in [DateTime] is
  # 
  # Example: 23 days ago
  def days_ago(date_time)
    days = (DateTime.now.to_date - date_time.to_date).to_i
    case days
    when 0
      t(:today)
    when 1
      t(:yesterday)
    else
      t(:days_ago).gsub('#', days.to_s)
    end
  end

  # Returns a mm:ss representation of a passed-in number of seconds.
  #
  # Optionally pass in a second number of seconds to return a range of mm:ss values
  # @param [Float, Int] seconds
  # @param [Float, Int] end_seconds
  def mm_ss(seconds, end_seconds = 0)
    mm = (seconds / 60).floor
    ss = "%02d" % (seconds % 60).to_i
    if end_seconds == 0
      "#{mm}:#{ss}"
    else
      "#{mm}:#{ss} - #{mm_ss(end_seconds)}"
    end
  end

end
