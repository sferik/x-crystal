require "../src/x"
require "spec"
require "webmock"

module SpecHelper
  def stub_request(http_method : Symbol, endpoint : String, status : Int32, headers : HTTP::Headers? = nil, body : String? = "{}")
    full_url = "#{X::ClientDefaults::DEFAULT_BASE_URL}#{endpoint}"
    WebMock.stub(http_method, full_url).to_return(status: status, body: body, headers: headers)
  end
end

Spec.before_each do
  WebMock.reset
end

include SpecHelper
