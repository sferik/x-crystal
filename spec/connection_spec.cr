require "./spec_helper"

describe X::Connection do
  describe "Initialization" do
    it "should set up with default values" do
      connection = X::Connection.new
      connection.base_uri.to_s.should eq "https://api.twitter.com/2/"
      connection.connect_timeout.should eq 60.seconds
      connection.read_timeout.should eq 60.seconds
      connection.write_timeout.should eq 60.seconds
    end
  end

  describe "base_uri changes" do
    it "should affect http_client settings" do
      connection = X::Connection.new(base_uri: URI.parse("https://api.twitter.com/2/"),
        connect_timeout: 10.seconds,
        read_timeout: 10.seconds,
        write_timeout: 10.seconds)

      connection.base_uri = URI.parse("http://api.x.com/2/")

      connection.http_client.host.should eq "api.x.com"
      connection.http_client.port.should eq 80
      connection.http_client.tls?.should be_falsey
    end

    it "should not change other settings after base_uri change" do
      connection = X::Connection.new(base_uri: URI.parse("https://api.twitter.com/2/"),
        connect_timeout: 10.seconds,
        read_timeout: 10.seconds,
        write_timeout: 10.seconds)

      connection.base_uri = URI.parse("http://api.x.com/2/")

      connection.connect_timeout.should eq 10.seconds
      connection.read_timeout.should eq 10.seconds
      connection.write_timeout.should eq 10.seconds
    end
  end
end
