require 'test_helper'

class RepiaTest < ActiveSupport::TestCase
  test "UniqueModel gets assigned a UUID at creation" do
    obj = UniqueModel.new()
    obj.save()
    assert_not_nil obj.uuid
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
end
