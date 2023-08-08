require "http/client"
require "uri"

module X
  # Creates HTTP requests
  class RequestBuilder
    HTTP_METHODS = {
      get:    "GET",
      post:   "POST",
      put:    "PUT",
      delete: "DELETE",
    }

    property! content_type : String?
    property! user_agent : String?

    def initialize(@content_type : String, @user_agent : String)
    end

    def build(authenticator : Authenticator, http_method : Symbol, base_url : URI, endpoint : String, body : String? = nil) : HTTP::Request
      url = URI.parse(Path[base_url.to_s, endpoint].to_s)
      request = create_request(http_method, url.to_s, body)
      add_content_type(request)
      add_user_agent(request)
      request
    end

    private def create_request(http_method : Symbol, url : String, body : String?) : HTTP::Request
      http_method_str = HTTP_METHODS[http_method]?

      raise ArgumentError.new("Unsupported HTTP method: #{http_method}") unless http_method_str

      request = HTTP::Request.new(http_method_str, url)
      request.body = body if body && http_method != :get
      request
    end

    private def add_content_type(request : HTTP::Request)
      request.headers["Content-Type"] = content_type
    end

    private def add_user_agent(request : HTTP::Request)
      request.headers["User-Agent"] = user_agent
    end
  end
end
