require 'net/http'
require 'uri'
require 'json'

class SlackNotifier
  def self.notify(text, webhook_url)
    return if webhook_url.blank?

    uri = URI.parse(webhook_url)
    header = { 'Content-Type': 'application/json' }
    payload = { text: text }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = payload.to_json
    http.request(request)
  end
end