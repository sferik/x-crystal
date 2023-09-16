require "./spec_helper"

describe X::RedirectHandler do
  describe "HTTP Redirects" do
    client = client()

    it "follows 301 redirect" do
      WebMock.stub(:get, "https://api.twitter.com/2/old_endpoint").to_return(
        status: 301,
        headers: {"Location" => "/new_endpoint"}
      )

      WebMock.stub(:get, "https://api.twitter.com/new_endpoint").to_return(
        status: 200,
        headers: {"content-type" => "application/json"},
        body: "{\"message\":\"success\"}"
      )

      response = client.get("old_endpoint")
      response["message"].should eq "success"
    end

    it "follows 302 redirect" do
      WebMock.stub(:get, "https://api.twitter.com/2/temporary_redirect").to_return(
        status: 302,
        headers: {"Location" => "https://api.twitter.com/new_endpoint"}
      )

      WebMock.stub(:get, "https://api.twitter.com/new_endpoint").to_return(
        status: 200,
        headers: {"content-type" => "application/json"},
        body: "{\"message\":\"success\"}"
      )

      response = client.get("temporary_redirect")
      response["message"].should eq "success"
    end

    it "follows 307 redirect preserving method and body" do
      WebMock.stub(:post, "https://api.twitter.com/2/temporary_redirect").to_return(
        status: 307,
        headers: {"Location" => "https://api.twitter.com/new_endpoint"}
      )

      WebMock.stub(:post, "https://api.twitter.com/new_endpoint").to_return(
        status: 200,
        headers: {"content-type" => "application/json"},
        body: "{\"message\":\"success\"}"
      )

      response = client.post("temporary_redirect", "{\"key\": \"value\"}")
      response["message"].should eq "success"
    end

    it "follows 308 redirect preserving method and body" do
      WebMock.stub(:post, "https://api.twitter.com/2/permanent_redirect").to_return(
        status: 308,
        headers: {"Location" => "https://api.twitter.com/new_endpoint"}
      )

      WebMock.stub(:post, "https://api.twitter.com/new_endpoint").to_return(
        status: 200,
        headers: {"content-type" => "application/json"},
        body: "{\"message\":\"success\"}"
      )

      response = client.post("permanent_redirect", "{\"key\": \"value\"}")
      response["message"].should eq "success"
    end

    it "avoids infinite redirect loop" do
      WebMock.stub(:get, "https://api.twitter.com/2/infinite_loop").to_return(
        status: 302,
        headers: {"Location" => "https://api.twitter.com/2/infinite_loop"}
      )

      expect_raises X::TooManyRedirectsError do
        client.get("infinite_loop")
      end
    end
  end
end
