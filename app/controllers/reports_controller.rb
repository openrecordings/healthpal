class ReportsController < ApplicationController
  def dashboard
    all_site_records = JSON.parse(get_records)
    @records = case current_user.role
    when 'root'
      all_site_records
    when 'admin'
  end

  private

  def get_records
    HTTParty.post(
      Rails.application.config.redcap_api_url,
      body: {
        token: Rails.application.config.redcap_api_key,
        content: 'record',
        format: 'json',
        type: 'flat'
      }
    ).body
  end
end
