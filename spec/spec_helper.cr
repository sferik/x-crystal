require "../src/x"
require "spec"
require "webmock"

TEST_BEARER_TOKEN        = "TEST_BEARER_TOKEN"
TEST_API_KEY             = "TEST_API_KEY"
TEST_API_KEY_SECRET      = "TEST_API_KEY_SECRET"
TEST_ACCESS_TOKEN        = "TEST_ACCESS_TOKEN"
TEST_ACCESS_TOKEN_SECRET = "TEST_ACCESS_TOKEN_SECRET"

def client
  X::Client.new(
    api_key: TEST_API_KEY,
    api_key_secret: TEST_API_KEY_SECRET,
    access_token: TEST_ACCESS_TOKEN,
    access_token_secret: TEST_ACCESS_TOKEN_SECRET
  )
end

Spec.before_each do
  WebMock.reset
end
