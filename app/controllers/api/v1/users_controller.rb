class Api::V1::UsersController < Api::ApiController
  def create
    render json: UsersSerializer.new(User.create!(user_params)), status: 201
  end

  private
  
    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
end
