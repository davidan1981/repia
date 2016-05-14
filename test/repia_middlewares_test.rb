require 'test_helper'

class RepiaTest < ActiveSupport::TestCase
  test "HttpMethodNotAllowed middleware throws 405 for invalid HTTP method" do
    app = lambda {|env| [200, {}, [""]]}
    stack = Repia::HttpMethodNotAllowed.new(app)
    request = Rack::MockRequest.new(stack)
    response = request.request("DOESNOTEXIST", "/users")
    assert response.headers["Content-Type"].include?("application/json")
    assert_equal 405, response.status.to_i
  end

  test "HttpMethodNotAllowed middleware does not throw 405 for valid HTTP method" do
    app = lambda {|env| [200, {}, [""]]}
    stack = Repia::HttpMethodNotAllowed.new(app)
    request = Rack::MockRequest.new(stack)
    response = request.request("GET", "/users")
    assert_equal 200, response.status.to_i
  end
end
