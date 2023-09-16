require "base64"
require "http/client"
# require "openssl/digest"
require "openssl/hmac"
require "uri"

module X
  # Handles OAuth authentication
  class OauthAuthenticator
    OAUTH_VERSION          = "1.0"
    OAUTH_SIGNATURE_METHOD = "HMAC-SHA1"
    OAUTH_ALGORITHM        = OpenSSL::Algorithm::SHA1

    property api_key : String
    property api_key_secret : String
    property access_token : String
    property access_token_secret : String

    def initialize(@api_key : String, @api_key_secret : String, @access_token : String, @access_token_secret : String)
    end

    def header(request : HTTP::Request)
      method, url, query_params = parse_request(request)
      build_oauth_header(method, url, query_params)
    end

    private def parse_request(request : HTTP::Request)
      uri = URI.parse(request.resource)
      query_params = uri.query_params
      {request.method.to_s, uri_without_query(uri), query_params}
    end

    private def uri_without_query(uri : URI)
      uri.to_s.chomp("?#{uri.query}")
    end

    private def build_oauth_header(method : String, url : String, query_params : URI::Params)
      oauth_params = default_oauth_params
      all_params = query_params.to_h.merge(oauth_params)
      oauth_params["oauth_signature"] = generate_signature(method, url, all_params)
      format_oauth_header(oauth_params)
    end

    private def default_oauth_params
      {
        "oauth_consumer_key"     => @api_key,
        "oauth_nonce"            => Random::Secure.hex,
        "oauth_signature_method" => OAUTH_SIGNATURE_METHOD,
        "oauth_timestamp"        => Time.utc.to_unix.to_s,
        "oauth_token"            => @access_token,
        "oauth_version"          => OAUTH_VERSION,
      }
    end

    private def generate_signature(method : String, url : String, params : Hash(String, String))
      base_string = signature_base_string(method, url, params)
      hmac_signature(base_string)
    end

    private def hmac_signature(base_string : String)
      hmac = OpenSSL::HMAC.digest(OAUTH_ALGORITHM, signing_key, base_string.to_slice)
      Base64.strict_encode(hmac)
    end

    private def signature_base_string(method : String, url : String, params : Hash(String, String))
      "#{method}&#{encode(url)}&#{encode(encode_params(params))}"
    end

    private def encode_params(params : Hash(String, String))
      params.to_a.sort.map { |k, v| "#{k}=#{encode(v)}" }.join("&")
    end

    private def signing_key
      "#{encode(@api_key_secret)}&#{encode(@access_token_secret)}"
    end

    private def format_oauth_header(params : Hash(String, String))
      "OAuth #{params.to_a.sort.map { |k, v| "#{k}=\"#{encode(v)}\"" }.join(", ")}"
    end

    private def encode(value : String)
      URI.encode_www_form(value)
    end
  end
end
