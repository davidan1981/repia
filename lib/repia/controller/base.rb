require 'json'
require_relative '../errors'
require_relative '../helper/base'

module Repia
  module Controller
    ##
    # This controller is a base controller for RESTful API. Two primary
    # features:
    #
    # - Error (exception) handling
    # - Options request handling
    #
    class Base < ActionController::Base
      include Helper::Base

      # This is a catch-all.
      rescue_from StandardError do |exception|
        logger.error exception.message
        render_error 500, "Unknown error occurred: #{exception.message}"
      end

      # Catch all manually thrown HTTP errors (predefined by repia)
      rescue_from Errors::HTTPError do |exception|
        status_code = exception.class.const_get("STATUS_CODE")
        message = exception.message || exception.class::MESSAGE
        logger.error "#{status_code} - #{message}"
        render_error status_code, message
      end
    end
  end
end
