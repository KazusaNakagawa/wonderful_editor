class Api::V1::Auth::RegistrationsController < ApplicationController

  def create
    # """転送されてきたデータを登録処理する """
    user = User.new(user_params)

    user.save!

    render json: user
  end

  private

    def user_params
      params.permit(:name, :password, :email)
    end
end
