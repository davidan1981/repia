require 'test_helper'

class RepiaTest < ActiveSupport::TestCase
  test "UniqueModel gets assigned a UUID at creation" do
    obj = UniqueModel.new()
    obj.save()
    assert_not_nil obj.uuid
  end

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

class DummiesControllerTest < ActionController::TestCase
  test "Predefined errors should be handled" do
    [400, 401, 404, 409, 500].each do |status_code|
      get :show, id: status_code
      assert_response status_code
    end
  end

  test "options request is handled" do
    get :options
    assert_response :success
    @request.headers["Access-Control-Request-Headers"] = "POST"
    get :options
    assert_response :success
    assert_equal "POST", @response.headers["Access-Control-Allow-Headers"]
  end

  test "render multiple errors" do
    get :index
    assert_response 400
  end

  test "handle standard error" do
    post :create
    assert_response 500
  end

  test "find_object will error if object does not exist" do
    patch :update, id: "blah"
    assert_response 404
  end

  test "find_object will find object if exists" do
    obj = UniqueModel.new()
    obj.save()
    patch :update, id: obj.uuid
    assert_response 200
  end

  test "exceptions_app" do
    delete :destroy, id: "blah"
    assert_response 404
  end
end
