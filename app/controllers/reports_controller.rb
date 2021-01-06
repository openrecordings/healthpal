class ReportsController < ApplicationController
  before_action :verify_privileged

  ID_VARIABLE = 'pt_id'.freeze
  
  def dashboard
    @records = case current_user.role
    when 'root'
      get_all_study_data_all_orgs
    when 'admin'
      get_study_data_for_org(current_user.org)
    end
  end

  private

  # This is the call to the REDCap API. This is the method that you would rewrite if your study
  # data were coming in from somewhere else external
  # TODO: Error handling
  def get_study_data_all_orgs
    records_array = JSON.parse(HTTParty.post(
        Rails.application.config.redcap_api_url,
        body: {
          token: Rails.application.config.redcap_api_key,
          content: 'record',
          format: 'json',
          type: 'flat'
        }
      ).body
    )
    return records_array.map{|record| OpenStruct.new(record)}
  end

  # REDCap records for a specific Org
  # NOTE: This is brittle in that it will include any mis-assigned IDs in REDCap
  def get_study_data_for_org(org)
    get_study_data_all_orgs.select do |record|
      record.send(ID_VARIABLE).start_with?(org.research_participant_id_prefix)
    end
  end

end
