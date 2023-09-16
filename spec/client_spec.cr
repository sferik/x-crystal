require "./spec_helper"

describe X::Client do
  describe "Initialization" do
    it "sets up a default client" do
      client = client()
      client.should_not be_nil
    end

    it "sets up a client with a bearer token" do
      client = X::Client.new(bearer_token: "TEST_BEARER_TOKEN")
      client.should_not be_nil
    end
  end

  {% for http_method in X::RequestBuilder::HTTP_METHODS %}
    it "test_{{http_method.downcase.id}}_oauth_request_success" do
      client = client()
      WebMock.stub({{http_method.downcase}}, "https://api.twitter.com/2/tweets").
        to_return(status: 200, body: "{}", headers: {"Content-Type" => "application/json"})
      response = client.{{http_method.downcase.id}}("tweets")
      response.should eq({} of String => String)
    end

    it "test_{{http_method.downcase.id}}_bearer_token_request_success" do
      client = X::Client.new(bearer_token: "TEST_BEARER_TOKEN")
      WebMock.stub({{http_method.downcase}}, "https://api.twitter.com/2/tweets").
        to_return(status: 200, body: "{}", headers: {"Content-Type" => "application/json"})
      response = client.{{http_method.downcase.id}}("tweets")
      response.should eq({} of String => String)
    end
  {% end %}

  it "checks default base uri" do
    client = client()
    client.base_uri.should eq(X::Connection::DEFAULT_BASE_URL)
  end

  it "allows setting base uri" do
    client = client()
    client.base_uri = URI.parse("https://example.com")
    client.base_uri.to_s.should eq("https://example.com")
  end

  it "checks default user agent" do
    client = client()
    client.user_agent.should eq(X::RequestBuilder::DEFAULT_USER_AGENT)
  end

  it "allows setting user agent" do
    client = client()
    client.user_agent = "Custom User Agent"
    client.user_agent.should eq("Custom User Agent")
  end

  it "checks default timeouts" do
    client = client()
    client.connect_timeout.should eq(X::Connection::DEFAULT_CONNECT_TIMEOUT)
    client.read_timeout.should eq(X::Connection::DEFAULT_READ_TIMEOUT)
    client.write_timeout.should eq(X::Connection::DEFAULT_WRITE_TIMEOUT)
  end

  it "allows setting timeouts" do
    client = client()
    client.connect_timeout = 10.seconds
    client.read_timeout = 10.seconds
    client.write_timeout = 10.seconds

    client.connect_timeout.should eq(10.seconds)
    client.read_timeout.should eq(10.seconds)
    client.write_timeout.should eq(10.seconds)
  end
end
