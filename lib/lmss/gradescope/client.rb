require 'faraday'
require 'faraday-cookie_jar'
require 'nokogiri'

require_relative 'error'

module Lmss
  module Gradescope
    class Client
      BASE_URL = 'https://www.gradescope.com'.freeze

      def initialize(email, password)
        @cookie_jar = HTTP::CookieJar.new
        @conn = Faraday.new(url: BASE_URL) do |f|
          f.request :url_encoded
          f.use :cookie_jar, jar: @cookie_jar
          f.adapter Faraday.default_adapter
        end
        login(email, password)
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
        # extract new csrf token after login
        @csrf_token = extract_csrf_token(res.body)
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
        response = @conn.post(path) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.headers['X-CSRF-Token'] = @csrf_token if @csrf_token
          req.body = data.to_json
        end
        handle_response(response)
      end

      def extract_all_react_props(html, data_react_class)
        doc = Nokogiri::HTML(html)
        elements = doc.css("[data-react-class='#{data_react_class}']")
        return [] if elements.empty?

        elements.map do |element|
          props_attr = element.attr('data-react-props')
          next nil unless props_attr

          begin
            JSON.parse(props_attr)
          rescue JSON::ParserError
            nil
          end
        end.compact # Remove nil values from failed JSON parsing
      end

      def extract_react_props(html, data_react_class)
        extract_all_react_props(html, data_react_class).first
      end

      private

      def handle_response(response)
        status = response.status

        case status
        when 200..299
          response.body
        when 401, 403
          raise AuthenticationErrors, 'Authentication required'
        when 404
          raise NotFoundError, 'Resource not found'
        else
          raise RequestError, "Request failed: #{status}"
        end
      end
    end
  end
end
