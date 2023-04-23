class Api::V1::SessionsController < Api::ApiController
  def create
    user = User.find_by(email: user_params[:email])

    if user&.authenticate(user_params[:password])
      render json: UsersSerializer.new(user), status: 200
    else
      render json: ErrorSerializer.new.invalid_credentials, status: 401
    end
  end

  private

    def user_params
      params.permit(:email, :password)
    end
end
