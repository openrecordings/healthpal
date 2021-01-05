class ReportsController < ApplicationController
  def dashboard
    @records = JSON.parse(get_records)
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
