module Api::V1
  class Articles::ArticleLikesController < BaseApiController
    before_action :authenticate_user!

    def create
      # """ いいねする """
      article_like = current_user.article_likes.create!(article_id: params[:article_id])
      render json: article_like, serializer: Api::V1::ArticleLikeSerializer
    end

    def destroy
      # """ いいね取り消す """
      article_like = current_user.article_likes.find(params[:id])
      article_like.destroy!
    end
  end
end
