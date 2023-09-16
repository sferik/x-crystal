require "http/client"
require "uri"
require "./connection"
require "./errors/too_many_redirects_error"

module X
  # Handles HTTP redirects
  class RedirectHandler
    DEFAULT_MAX_REDIRECTS = 10

    property authenticator : BearerTokenAuthenticator | OauthAuthenticator
    property connection : Connection
    property request_builder : RequestBuilder
    property max_redirects : Int32

    def initialize(@authenticator, @connection, @request_builder, @max_redirects = DEFAULT_MAX_REDIRECTS)
    end

    def handle_redirects(response : HTTP::Client::Response, original_request : HTTP::Request, original_base_url : URI, redirect_count : Int32 = 0)
      if response.status_code >= 300 && response.status_code < 400
        raise TooManyRedirectsError.new("Too many redirects") if redirect_count >= max_redirects

        new_uri = build_new_uri(response, original_base_url)
        new_request = build_request(original_request, new_uri)
        new_response = send_new_request(new_uri, new_request)

        handle_redirects(new_response, new_request, original_base_url, redirect_count + 1)
      else
        response
      end
    end

    private def build_new_uri(response : HTTP::Client::Response, original_base_url : URI)
      location = response.headers["Location"]?.to_s || ""
      new_uri = URI.parse(location)
      new_uri = URI.parse("#{original_base_url.scheme}://#{original_base_url.host}#{location}") if new_uri.relative?
      new_uri
    end

    private def build_request(original_request : HTTP::Request, new_uri : URI)
      http_method = original_request.method
      body = original_request.body
      request_builder.build(authenticator, http_method, new_uri, body: body)
    end

    private def send_new_request(new_uri : URI, new_request : HTTP::Request)
      @connection = Connection.new(base_uri: new_uri, connect_timeout: connection.connect_timeout,
        read_timeout: connection.read_timeout, write_timeout: connection.write_timeout)
      connection.send_request(new_request)
    end
  end
end
