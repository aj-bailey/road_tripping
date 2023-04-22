class Api::ApiController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :error_response

  def error_response(exception)
    error_serializer = ErrorSerializer.new(exception)
    render json: error_serializer.errors, status: error_serializer.status
  end
end