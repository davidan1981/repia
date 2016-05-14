require 'test_helper'

class TestsController < ApplicationController
end

class TestsControllerTest < ActionController::TestCase

  setup do
    Rails.application.routes.draw do
      match "tests" => "tests#index", via: [:get]
      match "tests/:id" => "tests#show", via: [:get]
      match "tests(/:id)" => "tests#options", via: [:options]
    end
    @controller = TestsController.new
  end

  test "Predefined errors should be handled" do
    class ::TestsController
      def show
        raise Repia::Errors::STATUS_CODE_TO_ERROR[params[:id].to_i]
      end
    end
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
    class ::TestsController
      def index
        self.render_errors(400, ["foo", "bar"])
      end
    end
    get :index
    assert_response 400
  end

  test "handle standard error" do
    class ::TestsController
      def index
        raise StandardError
      end
    end
    get :index
    assert_response 500
  end

  test "find_object will error if object does not exist" do
    class ::TestsController
      def show
        find_object UniqueModel, params[:id]
      end
    end
    get :show, id: "blah"
    assert_response 404
  end

  test "find_object will find object if exists" do
    obj = UniqueModel.new()
    obj.save()
    class ::TestsController
      def show
        find_object UniqueModel, params[:id]
        render json: {}, status: 200
      end
    end
    get :show, id: obj.uuid
    assert_response 200
  end

  test "exceptions_app" do
    class ::TestsController
      def show
        @exception = ActionController::RoutingError.new("blah")
        exceptions_app
      end
    end
    get :show, id: "blah"
    assert_response 404
  end
end
