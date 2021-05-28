class ReportsController < ApplicationController
  before_action :verify_privileged

  def dashboard
    @report = Report.new
  end
end

class Report
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
    @site_enrollment_by_period = _site_enrollment_by_period
    @site_names = {
      'DH' => 'Dartmouth',
      'UT' => 'University of Texas',
      'VU' => 'Vanderbilt University'
    }
    @enrollments_by_site = site_enrollments
    @use_metrics = _use_metrics
  end

  attr_accessor :sites, :enrollments, :enrollments_by_site, :site_names, :use_metrics

  def _use_metrics
    Recording.user_recordings
  end

  def site_enrollments
    enrollments = {}
    @sites.each {|site| enrollments[site] = @enrollments.select { |r| r.site == site }}
    enrollments
  end

  def recruitment_chart_data
    chart_data = []
    @sites.each do |site|
      enrollments = @enrollments.select { |r| r.site == site }
      n = enrollments.count
      org_data = {
        'org_name': @site_names[site],
        'n': n
      }
      xs = enrollments.map { |r| r.enrollment_date }
      ys = (1..n).to_a
      site_chart_data = []
      (1..n).each { |i| site_chart_data << { x: xs[i - 1], y: ys[i - 1] } }
      org_data['chart_data'] = site_chart_data
      chart_data << org_data
    end
    chart_data.to_json
  end

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

  def _site_enrollment_by_period
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
end
