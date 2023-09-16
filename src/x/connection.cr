require "http/client"
require "uri"

module X
  # Sends HTTP requests
  class Connection
    DEFAULT_BASE_URL        = URI.parse("https://api.twitter.com/2/")
    DEFAULT_HOST            = "https://api.twitter.com"
    DEFAULT_PORT            = 443
    DEFAULT_CONNECT_TIMEOUT = 60.seconds # in milliseconds
    DEFAULT_READ_TIMEOUT    = 60.seconds # in milliseconds
    DEFAULT_WRITE_TIMEOUT   = 60.seconds # in milliseconds
    NETWORK_ERRORS          = [IO::TimeoutError]

    property! base_uri : URI
    property! http_client : HTTP::Client
    property connect_timeout : Time::Span
    property read_timeout : Time::Span
    property write_timeout : Time::Span

    def initialize(
      @base_uri = DEFAULT_BASE_URL,
      @connect_timeout = DEFAULT_CONNECT_TIMEOUT,
      @read_timeout = DEFAULT_READ_TIMEOUT,
      @write_timeout = DEFAULT_WRITE_TIMEOUT
    )
      update_http_client_settings
    end

    def send_request(request : HTTP::Request)
      http_client.exec(request)
    rescue ex : IO::TimeoutError
      raise "Network error: #{ex.message}"
    end

    def base_uri=(base_uri : URI)
      uri = URI.parse(base_uri.to_s)
      raise ArgumentError.new("Invalid base URL") unless uri.scheme == "https" || uri.scheme == "http"

      @base_uri = uri
      update_http_client_settings
    end

    private def update_http_client_settings
      host = base_uri.host || DEFAULT_HOST
      tls = base_uri.scheme == "https"
      port = base_uri.port || tls ? 443 : 80

      @http_client = HTTP::Client.new(host, port, tls: tls)
      apply_http_client_settings
    end

    private def apply_http_client_settings
      http_client.read_timeout = @read_timeout
      http_client.write_timeout = @write_timeout
      http_client.connect_timeout = @connect_timeout
    end
  end
end
