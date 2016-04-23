class DummiesController < ApplicationController

  def index
    render_errors 400, ["one", "two"]
  end

  def create
    1 + "b"
  end

  def show
    status_code = params[:id].to_i
    case status_code
    when 400
      raise Repia::Errors::BadRequest
    when 401
      raise Repia::Errors::Unauthorized
    when 404
      raise Repia::Errors::NotFound
    when 409
      raise Repia::Errors::Conflict
    when 500
      raise Repia::Errors::InternalServerError
    end
  end
end
