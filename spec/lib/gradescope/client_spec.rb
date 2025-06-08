require 'spec_helper'

require 'gradescope/client'
require 'gradescope/gradescope'
require 'gradescope/version'

RSpec.describe Gradescope::Client do
  
  describe '.login' do
    it 'logs in successfully' do
      stub_request(:get, 'https://gradescope.com/login')
        .to_return(status: 200, body:
          "<meta name='csrf-token' content='abc'>" +
          "<meta name='csrf-token' content='abc'>"
        )
      
      stub_request(:post, 'https://gradescope.com/login')
        .to_return(status: 302, body: "dashboard")

      client = Gradescope::Client.new
      expect {
        client.login(
          ENV.fetch('GRADESCOPE_EMAIL'),
          ENV.fetch('GRADESCOPE_PASSWORD'))
    }.to be_a(Gradescope::Client)
end