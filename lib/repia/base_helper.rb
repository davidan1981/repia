require 'repia/errors'

module Repia

  ##
  # This helper module includes methods that are essential for building a
  # RESTful API.
  #
  module BaseHelper

    ##
    # Use this as an action triggered by exceptions_app to return a JSON
    # response to any middleware level exceptions.
    #
    # For example,
    #
    # config.exceptions_app = lambda { |env| 
    #   ApplicationController.action(:exceptions_app).call(env)
    # }
    #
    def exceptions_app
      ex_wrapper = ActionDispatch::ExceptionWrapper.new(Rails.env, @exception)
      status = ex_wrapper.status_code.to_i
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
end
