require "./bearer_token_authenticator"
require "./connection"
require "./oauth_authenticator"
require "./redirect_handler"
require "./request_builder"
require "./response_handler"

module X
  # Main public interface
  class Client
    getter! authenticator : BearerTokenAuthenticator | OauthAuthenticator
    getter connection : Connection
    getter request_builder : RequestBuilder
    getter redirect_handler : RedirectHandler
    getter response_handler : ResponseHandler
    delegate :base_uri, :connect_timeout, :read_timeout, :write_timeout, to: connection
    delegate :base_uri=, :connect_timeout=, :read_timeout=, :write_timeout=, to: connection
    delegate :content_type, :user_agent, to: request_builder
    delegate :content_type=, :user_agent=, to: request_builder
    delegate :max_redirects, to: redirect_handler
    delegate :max_redirects=, to: redirect_handler

    def initialize(
      bearer_token : String? = nil,
      api_key : String? = nil,
      api_key_secret : String? = nil,
      access_token : String? = nil,
      access_token_secret : String? = nil,
      base_uri : URI = Connection::DEFAULT_BASE_URL,
      connect_timeout : Time::Span | Int32 | Float64 = Connection::DEFAULT_CONNECT_TIMEOUT,
      read_timeout : Time::Span | Int32 | Float64 = Connection::DEFAULT_READ_TIMEOUT,
      write_timeout : Time::Span | Int32 | Float64 = Connection::DEFAULT_WRITE_TIMEOUT,
      content_type : String = RequestBuilder::DEFAULT_CONTENT_TYPE,
      user_agent : String = RequestBuilder::DEFAULT_USER_AGENT,
      max_redirects : Int32 = RedirectHandler::DEFAULT_MAX_REDIRECTS
    )
      initialize_authenticator(bearer_token, api_key, api_key_secret, access_token, access_token_secret)
      @connection = Connection.new(base_uri: base_uri, connect_timeout: connect_timeout, read_timeout: read_timeout, write_timeout: write_timeout)
      @request_builder = RequestBuilder.new(content_type: content_type, user_agent: user_agent)
      @redirect_handler = RedirectHandler.new(authenticator: authenticator, connection: connection, request_builder: request_builder, max_redirects: max_redirects)
      @response_handler = ResponseHandler.new
    end

    def get(endpoint : String)
      send_request("GET", endpoint)
    end

    def post(endpoint : String, body : String? = nil)
      send_request("POST", endpoint, body)
    end

    def put(endpoint : String, body : String? = nil)
      send_request("PUT", endpoint, body)
    end

    def delete(endpoint : String)
      send_request("DELETE", endpoint)
    end

    private def initialize_authenticator(bearer_token, api_key, api_key_secret, access_token, access_token_secret)
      @authenticator = if bearer_token
                         BearerTokenAuthenticator.new(bearer_token.as(String))
                       elsif api_key && api_key_secret && access_token && access_token_secret
                         OauthAuthenticator.new(api_key.as(String), api_key_secret.as(String), access_token.as(String), access_token_secret.as(String))
                       else
                         raise ArgumentError.new("Client must be initialized with either a bearer_token or an api_key, api_key_secret, access_token, and access_token_secret")
                       end
    end

    private def send_request(http_method : String, endpoint : String, body : String? = nil)
      uri = URI.parse(Path[base_uri.to_s, endpoint].to_s)
      request = request_builder.build(authenticator, http_method, uri, body: body)
      response = connection.send_request(request)
      final_response = redirect_handler.handle_redirects(response, request, base_uri)
      response_handler.handle(final_response)
    end
  end
end
