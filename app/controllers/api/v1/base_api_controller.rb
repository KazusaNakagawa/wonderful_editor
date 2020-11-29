class Api::V1::BaseApiController < ApplicationController
  def current_user
    # """ 認証Userをインスタン変数に格納 """
    @current_user ||= current_api_v1_user
  end

  def authenticate_user!
    # """ ログインしていないと使えない API
    # 記事: 作成, 更新, 削除
    # 認証Userであるか。 認証Userでなければ 401 """
  end

  def user_signed_in?
    # """ User が sign in しているか """
  end
end
