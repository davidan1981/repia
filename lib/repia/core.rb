require 'json'
require 'repia/errors'

module Repia

  ##
  # This module is a mixin that allows the model to use UUIDs instead of
  # normal IDs. By including this module, the model class declares that the
  # primary key is called "uuid" and an UUID is generated right before
  # save(). You may assign an UUID prior to save, in which case, no new UUID
  # will be generated.
  #
  module UUIDModel

    ##
    # Triggered when this module is included.
    #
    def self.included(klass)
      klass.primary_key = "uuid"
      klass.before_create :generate_uuid
    end

    ##
    # Generates an UUID for the model object.
    #
    def generate_uuid()
      self.uuid = UUIDTools::UUID.timestamp_create().to_s if self.uuid.nil?
    end
  end

  module BaseHelper

    ##
    # Use this as an action triggered by exceptions_app to return a JSON
    # response to any middleware level exceptions
    #
    def exceptions_app
      status = ActionDispatch::ExceptionWrapper.new(env, @exception).status_code.to_i
      error = Errors::STATUS_CODE_TO_ERROR[status]
      if error
        message = error::MESSAGE
      else 
        # :nocov:
        status = 500
        message = "Unknown error"
        # :nocov:
      end
      render_error status, message
    end

    ##
    # Renders a generic OPTIONS response. The actual controller must
    # override this action if desired to have specific OPTIONS handling
    # logic.
    #
    def options
      # echo back access-control-request-headers
      if request.headers["Access-Control-Request-Headers"]
        response["Access-Control-Allow-Headers"] =
            request.headers["Access-Control-Request-Headers"]
      end
      render body: "", status: 200
    end

    ##
    # Renders a single error.
    #
    def render_error(status, msg)
      render json: {errors: [msg]}, status: status
    end

    ##
    # Renders multiple errors
    #
    def render_errors(status, msgs)
      render json: {errors: msgs}, status: status
    end

    ##
    # Finds an object by model and UUID and throws an error (which will be
    # caught and re-thrown as an HTTP error) if the object does not exist.
    # The error can be optionally suppresed by specifying nil to error.
    #
    # An Repia::Errors::NotFound is raised if specified to do so when
    # the object could not be found using the uuid.
    #
    def find_object(model, uuid, error: Errors::NotFound)
      logger.debug("Attempting to get #{model.name} #{uuid}")
      obj = model.find_by_uuid(uuid)
      if obj.nil? && !error.nil?
        raise error, "#{model.name} #{uuid} cannot be found" 
      end
      return obj
    end

  end

  ##
  # This controller is a base controller for RESTful API. Two primary
  # features: 
  #
  # - Error (exception) handling
  # - Options request handling
  # 
  class BaseController < ActionController::Base
    include BaseHelper

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
