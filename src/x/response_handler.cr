require "http/client"
require "json"
require "./errors/authentication_error"
require "./errors/bad_request_error"
require "./errors/client_error"
require "./errors/error"
require "./errors/forbidden_error"
require "./errors/not_found_error"
require "./errors/server_error"
require "./errors/service_unavailable_error"
require "./errors/too_many_requests_error"

module X
  class ResponseHandler
    def handle(response : HTTP::Client::Response)
      case response.status_code
      when 200..299
        JSON.parse(response.body)
      when 400
        raise BadRequestError.new("400 Bad Request - #{response.body}")
      when 401
        raise AuthenticationError.new("401 Unauthorized - #{response.body}")
      when 403
        raise ForbiddenError.new("403 Forbidden - #{response.body}")
      when 404
        raise NotFoundError.new("404 Not Found - #{response.body}")
      when 429
        raise TooManyRequestsError.new("429 Too Many Requests - #{response.body}")
      when 400..499
        raise ClientError.new("#{response.status_code} Client Error - #{response.body}")
      when 503
        raise ServiceUnavailableError.new("503 Service Unavailable - #{response.body}")
      when 500..599
        raise ServerError.new("#{response.status_code} Server Error - #{response.body}")
      else
        raise Error.new("#{response.status_code} Unknown Response - #{response.body}")
      end
    end
  end
end
