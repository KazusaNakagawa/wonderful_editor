class Api::V1::BaseApiController < ApplicationController
  # sgin_in していない場合常に 401 Error を返す
  # before_action :authenticate_user!
  # before_action :authenticate_api_v1_user!, only: [:create, :update, :destory]

  # current_api_v1_user
  # authenticate_api_v1_user!
  # user_api_v1_signed_in?

  def current_user
    # """ 認証Userをインスタン変数に格納
    # currnet_api_v1_user()
    #
    #
    # """
    @current_user ||= current_api_v1_user
  end

  def authenticate_user!
    # """ ログインしていないと使えない API
    # 記事: 作成, 更新, 削除

    # 認証Userであるか。 認証Userでなければ 401 """

    # tokenがされていない場合
  end

  def user_signed_in?
    # """ User が sign in しているか """
  end
end
