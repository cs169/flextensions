require 'faraday'
require 'faraday-cookie_jar'

require 'nokogiri'

module Gradescope
  class Client
    BASE_URL = 'https://www.gradescope.com'.freeze

    def initialize
      @cookie_jar = HTTP::CookieJar.new
      @conn = Faraday.new(url: BASE_URL) do |f|
        f.request :url_encoded
        f.use :cookie_jar, jar: @cookie_jar
        f.adapter Faraday.default_adapter
      end
    end

    def login(email, password)
      html = @conn.get('/login')
      token = extract_csrf_token(html.body)

      # Login
      @conn.post('/login') do |req|
        req.body = {
          'utf8' => '✓',
          'authenticity_token' => token,
          'session[email]' => email,
          'session[password]' => password,
          'session[remember_me]' => 0,
          'session[remember_me_sso]' => 0,
          'commit' => 'Log In'
        }
      end

      # Confirm Gradescope log in
      res = @conn.get('/account')
      raise 'Failed to log in Gradescope' if res.status != 200
    end

    def extract_csrf_token(html)
      doc = Nokogiri::HTML(html)
      doc.at('meta[name="csrf-token"]')&.[]('content')
    end
  end
end
