module X
  class BearerTokenAuthenticator
    property bearer_token : String

    def initialize(@bearer_token : String)
    end

    def header(request : HTTP::Request)
      "Bearer #{@bearer_token}"
    end
  end
end
