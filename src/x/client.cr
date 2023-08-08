require "./authenticator"
require "./client_defaults"
require "./connection"
require "./request_builder"
require "./response_handler"

module X
  class Client
    include ClientDefaults

    property! content_type : String, user_agent : String
    delegate :api_key, :api_key_secret, :access_token, :access_token_secret, to: @authenticator
    delegate :base_url, to: @connection
    delegate :connect_timeout=, :read_timeout=, :write_timeout=, to: @connection

    def initialize(api_key : String, api_key_secret : String, access_token : String, access_token_secret : String,
                   @base_url : URI = DEFAULT_BASE_URL, @content_type : String = DEFAULT_CONTENT_TYPE, @user_agent : String = DEFAULT_USER_AGENT,
                   @connect_timeout : Time::Span | Float64 = DEFAULT_CONNECT_TIMEOUT, @read_timeout : Time::Span | Float64 = DEFAULT_READ_TIMEOUT, @write_timeout : Time::Span | Float64 = DEFAULT_WRITE_TIMEOUT)
      @authenticator = Authenticator.new(api_key: api_key, api_key_secret: api_key_secret,
        access_token: access_token, access_token_secret: access_token_secret, base_url: base_url)
      @connection = Connection.new(authenticator: @authenticator, base_url: base_url, connect_timeout: connect_timeout, read_timeout: read_timeout,
        write_timeout: write_timeout)
      @request_builder = RequestBuilder.new(content_type: content_type, user_agent: user_agent)
      @response_handler = ResponseHandler.new
    end

    def get(endpoint : String)
      send_request(:get, endpoint)
    end

    def post(endpoint : String, body : String? = nil)
      send_request(:post, endpoint, body)
    end

    def put(endpoint : String, body : String? = nil)
      send_request(:put, endpoint, body)
    end

    def delete(endpoint : String)
      send_request(:delete, endpoint)
    end

    private def send_request(http_method : Symbol, endpoint : String, body : String? = nil)
      request = @request_builder.build(@authenticator, http_method, base_url, endpoint, body)
      response = @connection.send_request(request)
      @response_handler.handle(response)
    end
  end
end
