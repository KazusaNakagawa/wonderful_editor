class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController
  # skip_before_action :authenticate_user!, only: [:create, :destroy]
  skip_before_action :verify_authenticity_token
  # protect_from_forgery with: :null_session

  # client_id = request.headers['client']

  protected

    def valid_params?(key, val)
      # binding.pry
      params[:session] && key && val
      # params.permit(:email, :password, :session)

      # origin -----------------
      # resource_params[:password] && key && val
    end
end
