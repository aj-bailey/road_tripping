class Api::V1::UsersController < ApplicationController
  def create
    user = User.create!(user_params)
    render json: UsersSerializer.new(user), status: 201
    # if user.save
    #   render json: UsersSerializer.new(user), status: 201
    # else
    #   render json: 
    # end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
end