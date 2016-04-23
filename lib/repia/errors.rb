
module Repia
  module Errors
    # List of HTTP Errors
    class HTTPError < StandardError; end
    class BadRequest < HTTPError; STATUS_CODE = 400; end
    class Unauthorized < HTTPError; STATUS_CODE = 401; end
    class NotFound < HTTPError; STATUS_CODE = 404; end
    class Conflict < HTTPError; STATUS_CODE = 409; end
    class InternalServerError < HTTPError; STATUS_CODE = 500; end
  end
end
