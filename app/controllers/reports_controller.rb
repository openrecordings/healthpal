class ReportsController < ApplicationController
  before_action :verify_privileged

  def dashboard
    @report = Report.new
  end
end

class Report
  def initialize
    @sites = %w[DH UT VU].freeze
    @site_names = {
      'DH' => 'Dartmouth',
      'UT' => 'University of Texas',
      'VU' => 'Vanderbilt University'
    }
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
    _row = Struct.new(*@csv_rows.shift.map { |name| name.to_sym })
    @all_rows = @csv_rows.map { |row| _row.new(*row) }
    @participants = _participants
    @participants_by_site = _participants_by_site(@participants)

    # Report types
    @recruitment_chart_data = _recruitment_chart_data
    @site_enrollment_by_period = _site_enrollment_by_period
    @enrollment_status = _enrollment_status
  end

  attr_accessor :sites, :participants, :participants_by_site, :site_names,
                :site_enrollment_by_period, :enrollment_status, :recruitment_chart_data

  class Participant
    def initialize(all_rows, pt_id)
      @pt_id = pt_id.freeze
      @rows = all_rows.select { |r| r.pt_id == pt_id }.freeze
      @enrollment = @rows.find { |r| r.redcap_event_name.include? 'participant_regist_arm_' }.freeze
      @t2_avs = @rows.find { |r| r.redcap_event_name.include? 't2_surveys_arm_' }.freeze
      @withdraw = @rows.find { |r| r.pt_withdraw_level.present? }.freeze
    end

    attr_accessor :pt_id

    def site
      @pt_id[0..1]
    end

    def enrollment_date
      @enrollment&.pt_enroll_date
    end

    def study_arm
      @enrollment&.pt_study_arm
    end

    def econsent
      @enrollment&.pt_econsent
    end

    def completed?
      return false if @t2_avs.nil?

      @t2_avs.t2_after_visit_summary_questions_both_arms_complete == '2'
    end

    def treatment_withdraw?
      return false if @withdraw.nil?

      @withdraw.pt_withdraw_level == '1'
    end

    def study_withdraw?
      return false if @withdraw.nil?

      @withdraw.pt_withdraw_level != '1'
    end
  end

  def _participants
    valid_rows = @all_rows.select { |row| @site_names.include? row.pt_id[0..1] }
    valid_rows.map { |r| r.pt_id }.uniq.map { |pt_id| Participant.new(@all_rows, pt_id) }
  end

  def _participants_by_site(participants)
    by_site = {}
    @sites.each { |site| by_site[site] = participants.select { |p| p.site == site } }
    by_site
  end

  def _recruitment_chart_data
    chart_data = []
    @sites.each do |site|
      participants = @participants_by_site[site]
      n = participants.count
      org_data = {
        'org_name': @site_names[site],
        'n': n
      }
      xs = participants.map { |r| r.enrollment_date }
      ys = (1..n).to_a
      site_chart_data = []
      (1..n).each { |i| site_chart_data << { x: xs[i - 1], y: ys[i - 1] } }
      org_data['chart_data'] = site_chart_data
      chart_data << org_data
    end
    chart_data.to_json
  end

  def _site_enrollment_by_period
    by_month = @participants.group_by { |r| Date.parse(r.enrollment_date).strftime('%B %Y') }
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

  def _enrollment_status
    statuses = {}
    participants = @participants_by_site
    participants['all'] = @participants
    participants.each_pair do |site, pts|
      statuses[site] = {}
      intervention = pts.select { |pt| pt.study_arm == '1' }
      usual_care = pts.select { |pt| pt.study_arm == '2' }

      # Number enrolled
      statuses[site]['enrolled_intervention'] = intervention.count
      statuses[site]['enrolled_usual_care'] = usual_care.count

      # eConsent
      statuses[site]['in_person_intervention'] = intervention.select do |e|
        e.econsent == '0'
      end.count
      statuses[site]['in_person_usual_care'] = usual_care.select { |pt| pt.econsent == '0' }.count
      statuses[site]['in_person_percent'] =
        (statuses[site]['in_person_intervention'] + statuses[site]['in_person_usual_care']) / @participants.count.to_f * 100.0
      statuses[site]['econsent_intervention'] = intervention.select do |pt|
        pt.econsent == '1'
      end.count
      statuses[site]['econsent_usual_care'] = usual_care.select { |pt| pt.econsent == '1' }.count
      statuses[site]['econsent_percent'] =
        (statuses[site]['econsent_intervention'] + statuses[site]['econsent_usual_care']) / @participants.count.to_f * 100.0

      # Completion status
      statuses[site]['completed_intervention'] = intervention.select { |pt| pt.completed? }.count
      statuses[site]['completed_usual_care'] = usual_care.select { |pt| pt.completed? }.count
      statuses[site]['completed_percent'] =
        (statuses[site]['completed_intervention'] + statuses[site]['completed_usual_care']) / @participants.count.to_f * 100.0
    end
    statuses
  end
end
