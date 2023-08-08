require "uri"
require "./version"

module X
  module ClientDefaults
    DEFAULT_BASE_URL        = URI.parse("https://api.twitter.com/2/")
    DEFAULT_HOST            = "api.twitter.com"
    DEFAULT_PORT            = 443
    DEFAULT_CONTENT_TYPE    = "application/json; charset=utf-8"
    DEFAULT_CONNECT_TIMEOUT = 60.seconds
    DEFAULT_READ_TIMEOUT    = 60.seconds
    DEFAULT_WRITE_TIMEOUT   = 60.seconds
    DEFAULT_USER_AGENT      = "X-Client/#{X::VERSION} Crystal/#{Crystal::VERSION}"
  end
end
