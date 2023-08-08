require "./spec_helper"

module X
  describe ResponseHandler do
    it "handles a successful response" do
      response = HTTP::Client::Response.new(200, "{\"status\":\"success\"}")
      handler = ResponseHandler.new
      result = handler.handle(response)
      result.should eq({"status" => "success"})
    end

    it "raises a BadRequestError for a 400 response" do
      response = HTTP::Client::Response.new(400, "Bad Request")
      handler = ResponseHandler.new
      expect_raises BadRequestError, "400 Bad Request - Bad Request" do
        handler.handle(response)
      end
    end

    it "raises a AuthenticationError for a 401 response" do
      response = HTTP::Client::Response.new(401, "Unauthorized")
      handler = ResponseHandler.new
      expect_raises AuthenticationError, "401 Unauthorized - Unauthorized" do
        handler.handle(response)
      end
    end

    it "raises a ForbiddenError for a 403 response" do
      response = HTTP::Client::Response.new(403, "Forbidden")
      handler = ResponseHandler.new
      expect_raises ForbiddenError, "403 Forbidden - Forbidden" do
        handler.handle(response)
      end
    end

    it "raises a NotFoundError for a 404 response" do
      response = HTTP::Client::Response.new(404, "Not Found")
      handler = ResponseHandler.new
      expect_raises NotFoundError, "404 Not Found - Not Found" do
        handler.handle(response)
      end
    end

    it "raises a TooManyRequestsError for a 429 response" do
      response = HTTP::Client::Response.new(429, "Too Many Requests")
      handler = ResponseHandler.new
      expect_raises TooManyRequestsError, "429 Too Many Requests - Too Many Requests" do
        handler.handle(response)
      end
    end

    it "raises a ClientError for a 499 response" do
      response = HTTP::Client::Response.new(499, "Client Error")
      handler = ResponseHandler.new
      expect_raises ClientError, "499 Client Error - Client Error" do
        handler.handle(response)
      end
    end

    it "raises a ServerError for a 500 response" do
      response = HTTP::Client::Response.new(500, "Internal Server Error")
      handler = ResponseHandler.new
      expect_raises ServerError, "500 Server Error - Internal Server Error" do
        handler.handle(response)
      end
    end

    it "raises a ServerError for a 503 response" do
      response = HTTP::Client::Response.new(503, "Service Unavailable")
      handler = ResponseHandler.new
      expect_raises ServiceUnavailableError, "503 Service Unavailable - Service Unavailable" do
        handler.handle(response)
      end
    end

    it "raises an Error for an unknown response" do
      response = HTTP::Client::Response.new(600, "Unknown")
      handler = ResponseHandler.new
      expect_raises Error, "600 Unknown Response - Unknown" do
        handler.handle(response)
      end
    end
  end
end
