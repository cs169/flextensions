require 'rails_helper'

RSpec.describe "Status", type: :request do
  describe "GET /status/health_check" do
    it "returns ok status and db connectivity" do
      get "/status/health_check"
      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json["status"]).to eq("ok")
      expect(json["database"]).to be(true)
    end
  end

  describe "GET /status/version" do
    it "returns version, git info, puma start time, and server time" do
      allow_any_instance_of(StatusController).to receive(:fetch_git_commit).and_return("abc123")
      allow_any_instance_of(StatusController).to receive(:fetch_puma_start_time).and_return(Time.zone.now)
      get "/status/version"
      expect(response).to have_http_status(:ok)
      json = response.parsed_body
      expect(json["git_commit"]).to eq("abc123")
      expect(json["puma_start_time"]).not_to be_nil
      expect(json["server_time"]).not_to be_nil
    end
  end
end
