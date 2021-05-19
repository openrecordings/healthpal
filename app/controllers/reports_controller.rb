class ReportsController < ApplicationController
  before_action :verify_privileged

  ID_VARIABLE = 'pt_id'.freeze

  DAY_ZERO = DateTime.parse('2020-10-18')

  def dashboard
    # @recruitment_data = []
    # [
    #   Org.find(1),
    #   Org.find(2),
    #   Org.find(3),
    # ].each do |org| 
    #   pts = org.participants.order(:registered_at).to_a.map{|pt| pt.attributes}
    #   @n = pts.count
    #   org_data = {'org_name': org.name, 'n': @n, 'participants': pts}
    #   xs = [DAY_ZERO].concat(pts.map{|pt| pt['registered_at']})
    #   ys = [0].concat((1..@n).to_a)
    #   chart_data = []
    #   (0..(@n)).each{|i| chart_data << {x: xs[i].strftime('%F'), y: ys[i]}} 
    #   org_data['chart_data'] = chart_data
    #   @recruitment_data << org_data
    # end
    # @recruitment_data = @recruitment_data.to_json

    redcap_records = case current_user.role
               when 'root'
                 get_study_data_all_orgs
               when 'admin'
                 # get_study_data_for_org(current_user.org)
                 get_study_data_all_orgs
               end
    @redcap_records = filter_redcap_records(redcap_records)
  end

  private

  # Keeps only the needed properties of the REDCap JSON objects from the "report" API call
  def filter_redcap_records(records)
    kept_keys = ['pt_email_address']
    records.select {|record| record['redcap_event_name'].include?('participant_regist_arm_')}
    records.map {|record| record.select {|key, value| kept_keys.include?(key) && value.present?}}
  end

  # This is the call to the REDCap API. This is the method that you would rewrite if your study
  # data were coming in from somewhere else external. Returns an Array of OpenStructs
  # TODO: Error handling
  def get_study_data_all_orgs
    JSON.parse(
      HTTParty.post(
        Rails.application.config.redcap_api_url,
        body: {
          token: Rails.application.config.redcap_api_key,
          content: 'report',
          report_id: '3516',
          format: 'json',
          raw_or_label: 'label',
          raw_or_label_headers: 'label',
          export_checkbox_label: 'true'
        }
      ).body
    # ).map { |record| OpenStruct.new(record) }.select { |record| !record.send(ID_VARIABLE).downcase.include?('test') }
    )
  end

  # REDCap records for a specific Org
  # NOTE: This is brittle in that it will include any mis-assigned IDs in REDCap
  def get_study_data_for_org(org)
    get_study_data_all_orgs.select do |record|
      record.send(ID_VARIABLE).start_with?(org.research_participant_id_prefix)
    end
  end
end
