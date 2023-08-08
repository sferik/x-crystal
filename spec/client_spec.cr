require "./spec_helper"

module X
  describe Client do
    client = Client.new(api_key: "api_key", api_key_secret: "api_key_secret", access_token: "access_token", access_token_secret: "access_token_secret")

    describe "#get" do
      it "sends a GET request" do
        endpoint = "test_endpoint"
        stub_request(:get, endpoint, 200)
        response = client.get(endpoint)
        response.should eq({} of String => String)
      end
    end

    describe "#post" do
      it "sends a POST request with body" do
        endpoint = "test_endpoint"
        body = "{\"data\":\"test\"}"
        stub_request(:post, endpoint, 200)
        response = client.post(endpoint, body)
        response.should eq({} of String => String)
      end
    end

    describe "#put" do
      it "sends a PUT request with body" do
        endpoint = "test_endpoint"
        body = "{\"data\":\"test\"}"
        stub_request(:put, endpoint, 200)
        response = client.put(endpoint, body)
        response.should eq({} of String => String)
      end
    end

    describe "#delete" do
      it "sends a DELETE request" do
        endpoint = "test_endpoint"
        stub_request(:delete, endpoint, 200)
        response = client.delete(endpoint)
        response.should eq({} of String => String)
      end
    end
  end
end
