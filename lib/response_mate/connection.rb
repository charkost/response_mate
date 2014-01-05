# coding: utf-8

# This class provides a layer above the HTTP client
class ResponseMate::Connection

  delegate :params, to: :client
  delegate(*(ResponseMate::ManifestParser::HTTP_VERBS), to: :client)

  attr_accessor :client, :base_url

  def initialize(base_url = nil)
    @base_url = base_url
    @client = Faraday.new do |c|
      c.use FaradayMiddleware::FollowRedirects, limit: 5
      c.adapter Faraday.default_adapter
    end

    client.headers.merge(ResponseMate::DEFAULT_HEADERS)
    client.url_prefix = base_url if base_url
  end

  def fetch(request)
    client.params = request[:params] if !request[:params].nil?
    unless base_url || request[:path] =~ %r{http://}
      request[:path] = 'http://' + request[:path]
    end
    client.send request[:verb].downcase.to_sym, "#{base_url}#{request[:path]}"
  rescue Faraday::Error::ConnectionFailed
    puts "Is a server up and running at #{request[:path]}?".red
    exit 1
  end

  def set_headers_from_manifest(manifest)
    return if !manifest.default_headers

    manifest.default_headers.each do |k, v|
      client.headers[ResponseMate::Helpers.headerize(k)] = v
    end
  end
end
