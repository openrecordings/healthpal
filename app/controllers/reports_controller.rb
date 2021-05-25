class ReportsController < ApplicationController
  before_action :verify_privileged

  def dashboard
    @report = Report.new
  end
end

class Report
  class Record
    def initialize(row)
      @row = row
    end

    attr_accessor :row

    def site
      row.pt_id[0..1]
    end

    def enrollment_date
      row.pt_enroll_date
    end

    def event_name
      row.redcap_event_name
    end
  end

  def clean_records(records)
    records.select { |r| @sites.include? r.site }
  end

  def site_enrollment_by_period
    by_month = @enrollments.group_by { |r| Date.parse(r.enrollment_date).strftime('%B %Y') }
    months = by_month.keys
    counts = {}
    months.each do |month|
      month_counts = {}
      @sites.each do |site|
        month_counts[site] = by_month[month].select { |record| record.site == site }.count
      end
      counts[month] = month_counts
    end
    counts
  end

  def initialize
    @sites = %w[DH UT VU].freeze
    @csv_rows = CSV.parse(HTTParty.post(
      Rails.application.config.redcap_api_url,
      body: {
        token: Rails.application.config.redcap_api_key,
        content: 'report',
        report_id: '4085',
        format: 'csv',
        raw_or_label: 'raw',
        raw_or_label_headers: 'raw',
        export_checkbox_label: 'true'
      }
    ).body)
    @row = Struct.new(*@csv_rows.shift.map { |name| name.to_sym })
    @records = clean_records(@csv_rows.map { |row| Record.new(@row.new(*row)) })
    @enrollments = @records.select { |r| r.event_name.include? 'participant_regist_arm_' }.freeze
    @site_enrollment_by_period = site_enrollment_by_period
  end

end
