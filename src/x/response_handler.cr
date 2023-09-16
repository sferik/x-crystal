require "json"
require "http/client"
require "./errors/bad_request_error"
require "./errors/authentication_error"
require "./errors/forbidden_error"
require "./errors/not_found_error"
require "./errors/too_many_requests_error"
require "./errors/server_error"
require "./errors/service_unavailable_error"

module X
  # Process HTTP responses
  class ResponseHandler
    JSON_CONTENT_TYPE_REGEXP = /^application\/(problem\+|)json/

    def handle(response : HTTP::Client::Response)
      if successful_json_response?(response)
        JSON.parse(response.body)
      else
        error_class = error_class_for_code(response.status_code)
        error_message = "#{response.status_code} #{response.status_message}"
        raise error_class.new(error_message)
      end
    end

    private def successful_json_response?(response : HTTP::Client::Response)
      response.success? && response.body && JSON_CONTENT_TYPE_REGEXP =~ response.headers["Content-Type"]?
    end

    private def error_class_for_code(status_code : Int32)
      case status_code
      when 400      then BadRequestError
      when 401      then AuthenticationError
      when 403      then ForbiddenError
      when 404      then NotFoundError
      when 429      then TooManyRequestsError
      when 400..499 then ClientError
      when 503      then ServiceUnavailableError
      when 500..500 then ServerError
      else
        raise Error.new("Unknown status code: #{status_code}")
      end
    end
  end
end
