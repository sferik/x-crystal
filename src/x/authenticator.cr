require "oauth"
require "uri"
require "./client_defaults"

module X
  class Authenticator
    include ClientDefaults

    getter! api_key : String
    getter! api_key_secret : String
    getter! access_token : String
    getter! access_token_secret : String
    getter! oauth_access_token : OAuth::AccessToken
    getter! oauth_consumer : OAuth::Consumer

    def initialize(base_url : URI, @api_key : String, @api_key_secret : String, @access_token : String, @access_token_secret : String)
      host = base_url.host || DEFAULT_HOST
      @oauth_consumer = OAuth::Consumer.new(host, api_key, api_key_secret)
      @oauth_access_token = OAuth::AccessToken.new(access_token, access_token_secret)
    end

    def authenticate(http_client : HTTP::Client)
      oauth_consumer.authenticate(http_client, oauth_access_token)
    end
  end
end
