class Api::V1::BaseApiController < ApplicationController
  # ref: https://devise-token-auth.gitbook.io/devise-token-auth/usage/controller_methods#methods

  def current_user
    # 自己代入: https://docs.ruby-lang.org/ja/2.5.0/doc/spec=2foperator.html#selfassign
    # : 仮userとして最初の登録userを使用
    binding.pry
    @current_user ||= User.first
  end
end
