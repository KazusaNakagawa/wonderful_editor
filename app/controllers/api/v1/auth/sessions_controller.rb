class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController
  # def sign_in_params
  #   params.permit(:email, :password)
  # end

  def create
    params.permit(:email, :password)
    render json: current_user
  end

  # protected

  #   def valid_params?(key, val)
  #     # resource_params[:name] && key && val
  #     resource_params[:email] && key && val
  #     # params.permit(:email, :password)
  #   end

  private

    def resource_params
      params.permit(:password, :login)
    end
end
