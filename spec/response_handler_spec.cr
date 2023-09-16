require "./spec_helper"

describe X::ResponseHandler do
  it "handles a successful response" do
    response = HTTP::Client::Response.new(200, "{\"status\":\"success\"}", HTTP::Headers{"Content-Type" => "application/json"})
    handler = X::ResponseHandler.new
    result = handler.handle(response)
    result.should eq({"status" => "success"})
  end

  it "raises a BadRequestError for a 400 response" do
    response = HTTP::Client::Response.new(400, "Bad Request")
    handler = X::ResponseHandler.new
    expect_raises X::BadRequestError do
      handler.handle(response)
    end
  end

  it "raises a AuthenticationError for a 401 response" do
    response = HTTP::Client::Response.new(401, "Unauthorized")
    handler = X::ResponseHandler.new
    expect_raises X::AuthenticationError do
      handler.handle(response)
    end
  end

  it "raises a ForbiddenError for a 403 response" do
    response = HTTP::Client::Response.new(403, "Forbidden")
    handler = X::ResponseHandler.new
    expect_raises X::ForbiddenError do
      handler.handle(response)
    end
  end

  it "raises a NotFoundError for a 404 response" do
    response = HTTP::Client::Response.new(404, "Not Found")
    handler = X::ResponseHandler.new
    expect_raises X::NotFoundError do
      handler.handle(response)
    end
  end

  it "raises a TooManyRequestsError for a 429 response" do
    response = HTTP::Client::Response.new(429, "Too Many Requests")
    handler = X::ResponseHandler.new
    expect_raises X::TooManyRequestsError do
      handler.handle(response)
    end
  end

  it "raises a ClientError for a 499 response" do
    response = HTTP::Client::Response.new(499, "Client Error")
    handler = X::ResponseHandler.new
    expect_raises X::ClientError do
      handler.handle(response)
    end
  end

  it "raises a ServerError for a 500 response" do
    response = HTTP::Client::Response.new(500, "Internal Server Error")
    handler = X::ResponseHandler.new
    expect_raises X::ServerError do
      handler.handle(response)
    end
  end

  it "raises a ServerError for a 503 response" do
    response = HTTP::Client::Response.new(503, "Service Unavailable")
    handler = X::ResponseHandler.new
    expect_raises X::ServiceUnavailableError do
      handler.handle(response)
    end
  end

  it "raises an Error for an unknown response" do
    response = HTTP::Client::Response.new(600, "Unknown")
    handler = X::ResponseHandler.new
    expect_raises X::Error do
      handler.handle(response)
    end
  end
end
