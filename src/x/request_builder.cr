require "http/client"
require "./version"

module X
  # Creates HTTP requests
  class RequestBuilder
    HTTP_METHODS         = ["GET", "POST", "PUT", "DELETE"]
    DEFAULT_CONTENT_TYPE = "application/json; charset=utf-8"
    DEFAULT_USER_AGENT   = "X-Client/#{VERSION} Crystal/#{Crystal::VERSION}"
    AUTHORIZATION_HEADER = "Authorization"
    CONTENT_TYPE_HEADER  = "Content-Type"
    USER_AGENT_HEADER    = "User-Agent"

    property content_type : String
    property user_agent : String

    def initialize(@content_type : String = DEFAULT_CONTENT_TYPE, @user_agent : String = DEFAULT_USER_AGENT)
    end

    def build(authenticator : BearerTokenAuthenticator | OauthAuthenticator, http_method : String, url : URI, body : IO? | String? = nil) : HTTP::Request
      unless HTTP_METHODS.includes?(http_method)
        raise ArgumentError.new("Unsupported HTTP method: #{http_method}")
      end

      request = create_request(http_method, url, body)
      add_authorization(request, authenticator)
      add_content_type(request)
      add_user_agent(request)
      request
    end

    private def create_request(http_method : String, url : URI, body : IO? | String?) : HTTP::Request
      headers = HTTP::Headers.new
      request = HTTP::Request.new(http_method, url.to_s, headers)

      request.body = body if body && http_method != "GET"
      request
    end

    private def add_authorization(request : HTTP::Request, authenticator)
      request.headers[AUTHORIZATION_HEADER] = authenticator.header(request)
    end

    private def add_content_type(request : HTTP::Request)
      request.headers[CONTENT_TYPE_HEADER] = @content_type if @content_type
    end

    private def add_user_agent(request : HTTP::Request)
      request.headers[USER_AGENT_HEADER] = @user_agent if @user_agent
    end
  end
end
