class Api::V1::Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  skip_before_action :verify_authenticity_token

  private

    def sign_up_params
      # """転送されてきたデータを認証し登録する
      # passの値が合わないと認証が, 弾かれる
      # """
      # URL: POST / http://localhost:3000/api/v1/auth/
      # Exsample
      #   request ----------------------------
      #   {
      #     "name": "name-name-json",
      #     "email": "test@x-hack.jp",
      #     "password": "123456",
      #     "password_confirmation": "123456"
      #   }
      #
      #   response ---------------------------
      #   {
      #      "status": "success",
      #      "data": {
      #         "id": 14,
      #         "provider": "email",
      #         "uid": "test@x-hack.jp",
      #         "allow_password_change": false,
      #         "name": "name-name-json",
      #         "image": null,
      #         "email": "test@x-hack.jp",
      #         "created_at": "2020-11-03T03:33:39.917Z",
      #         "updated_at": "2020-11-03T03:33:40.019Z"
      #      }
      #   }
      params.permit(:name, :email, :password, :password_confirmation)
    end

    def account_update_params
      params.permit(:name, :email)
    end
end
