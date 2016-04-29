module Repia
  ##
  # This class serves as a middleware to handle Method Not Allowed error
  # (which is not handled by show_exceptions for some reason).
  #
  # Code was excerpted from https://gist.github.com/viola/1243572 and was
  # modified to serve a JSON response.
  #
  # Add it after ActionDispatch::RequestId to keep the request ID in the
  # response headers.
  #
  class HttpMethodNotAllowed
    def initialize(app)
      @app = app
    end

    def call(env)
      if !ActionDispatch::Request::HTTP_METHODS.include?(env["REQUEST_METHOD"].upcase)
        Rails.logger.info("ActionController::UnknownHttpMethod: #{env.inspect}")
        [405, 
         {"Content-Type" => "application/json; charset=utf-8"},
         [JSON.generate({errors: ["Method not allowed"]})]
        ]
      else
        @status, @headers, @response = @app.call(env)
        [@status, @headers, @response]
      end
    end
  end
end
