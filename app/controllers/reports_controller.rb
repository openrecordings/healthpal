class ReportsController < ApplicationController
  def dashboard
    @records = get_records
  end

  private

  def get_records
    post_fields = {
      token: Settings::API_TOKEN,
      content: 'record',
      format: 'json',
      type: 'flat'
    }
    Curl::Easy.http_post(
      Settings::API_URL,
      fields.collect { |k, v| Curl::PostField.content(k.to_s, v) }
    ).body_str
  end

end
