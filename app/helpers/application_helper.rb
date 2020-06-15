module ApplicationHelper
  def app_display_name
    Orals::Application.credentials.app_display_name || 'Open Recordings'
  end

  # Example: Mon, 09 Nov 2009 00:00:00 +0000 => 11/09/09 12:00 AM
  def format_date(date_time)
    date_time.strftime('%-m/%-d/%Y') if date_time
  end

  # Example: Mon, 09 Nov 2009 00:00:00 +0000 => 11/09/09 12:00 AM
  def format_date_time(date_time)
    date_time.strftime('%m/%d/%y %I:%M %p') if date_time
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

  # Example: 23 days ago
  def days_ago(date_time)
    days = (DateTime.now.to_date - date_time.to_date).to_i
    case days
    when 0
      'Today'
    when 1
      'Yesterday'
    else
      "#{days} days ago"
    end
  end

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
