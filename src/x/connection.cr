require "http/client"
require "uri"
require "./client_defaults"

module X
  # Sends HTTP requests
  class Connection
    include ClientDefaults

    getter! base_url : URI
    getter! client : HTTP::Client
    delegate :connect_timeout=, :read_timeout=, :write_timeout=, to: client

    def initialize(authenticator : Authenticator, @base_url : URI, connect_timeout : Time::Span | Float64, read_timeout : Time::Span | Float64, write_timeout : Time::Span | Float64)
      raise ArgumentError.new("Invalid base URL") unless base_url.scheme == "https" || base_url.scheme == "http"
      host = base_url.host || DEFAULT_HOST
      port = base_url.port || DEFAULT_PORT
      tls = base_url.scheme == "https"
      @client = HTTP::Client.new(host, port, tls: tls)
      client.connect_timeout = connect_timeout
      client.read_timeout = read_timeout
      client.write_timeout = write_timeout
      authenticator.authenticate(client)
    end

    def send_request(request : HTTP::Request)
      client.exec(request.method, request.resource, headers: request.headers, body: request.body)
    end
  end
end
