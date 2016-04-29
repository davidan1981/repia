
module Repia
  module Errors
    # List of HTTP Errors
    class HTTPError < StandardError; end
    class BadRequest < HTTPError; STATUS_CODE = 400; end
    class Unauthorized < HTTPError; STATUS_CODE = 401; end
    class PaymentRequired < HTTPError; STATUS_CODE = 402; end
    class Forbidden < HTTPError; STATUS_CODE = 403; end
    class NotFound < HTTPError; STATUS_CODE = 404; end
    class MethodNotAllowed < HTTPError; STATUS_CODE = 405; end
    class NotAcceptable < HTTPError; STATUS_CODE = 406; end
    class ProxyAuthenticationRequired < HTTPError; STATUS_CODE = 407; end
    class RequestTimeout < HTTPError; STATUS_CODE = 408; end
    class Conflict < HTTPError; STATUS_CODE = 409; end
    class Gone < HTTPError; STATUS_CODE = 410; end
    class LengthRequired < HTTPError; STATUS_CODE = 411; end
    class PreconditionFailed < HTTPError; STATUS_CODE = 412; end
    class RequestEntityTooLarge < HTTPError; STATUS_CODE = 413; end
    class RequestURITooLong < HTTPError; STATUS_CODE = 414; end
    class UnsupportedMediaType < HTTPError; STATUS_CODE = 415; end
    class RequestedRangeNotSatisfiable < HTTPError; STATUS_CODE = 416; end
    class ExpectationFailed < HTTPError; STATUS_CODE = 417; end
    class InternalServerError < HTTPError; STATUS_CODE = 500; end
    class NotImplemented < HTTPError; STATUS_CODE = 501; end
    class BadGateway < HTTPError; STATUS_CODE = 502; end
    class ServiceUnavailable < HTTPError; STATUS_CODE = 503; end
    class GatewayTimeout < HTTPError; STATUS_CODE = 504; end
    class HTTPVersionNotSupported < HTTPError; STATUS_CODE = 505; end

    # At loading time, create a map and store a humanized error message for
    # convenience.
    STATUS_CODE_TO_ERROR = {}
    HTTPError.subclasses.each do |error|
      STATUS_CODE_TO_ERROR[error::STATUS_CODE] = error
      error::MESSAGE = error.name.split("::").last.underscore.humanize
    end
  end
end
