class Api::V1::Auth::RegistrationsController < ApplicationController
  def create
    # """ 転送されてきたデータを登録処理する """
    user = User.new(name: params[:name],
                    password: params[:password],
                    email: params[:email])
    user.save!

    render json: user
  end

  # private

  #   def sign_up_params
  #     # ここに :age, :genderを追記
  #     params.permit(:name, :email, :age, :gender, :password, :password_confirmation)
  #   end

  #   def account_update_params
  #     params.permit(:name, :email)
  #   end
end
