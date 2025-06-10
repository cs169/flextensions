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
      raise AuthenticationError, 'Login failed' if res.status != 200
    end

    def extract_csrf_token(html)
      doc = Nokogiri::HTML(html)
      doc.at('meta[name="csrf-token"]')&.[]('content')
    end

    def get(path)
      response = @conn.get(path)
      handle_response(response)
    end

    def post(path, data)
      response = @conn.post(
        path, {
          body: data.to_json
        }
      )
      handle_response(response)
    end

    def extract_react_props(html, data_react_class)
      doc = Nokogiri::HTML(html)
      element = doc.css("[data-react-class='#{data_react_class}']").first
      return nil unless element

      props_attr = element.attr('data-react-props')
      return nil unless props_attr

      JSON.parse(props_attr)
    rescue JSON::ParserError
      nil
    end

    private

    def handle_response(response)
      case response.status
      when 200..299
        response
        # when 401, 403
        #   raise AuthenticationError, 'Authentication required'
        # when 404
        #   raise NotFoundError, 'Resource not found'
        # else
        #   raise RequestError, "Request failed: #{response.code}"
      end
    end
  end
end
