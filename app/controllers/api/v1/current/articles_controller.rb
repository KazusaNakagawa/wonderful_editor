module Api::V1
  class Current::ArticlesController < BaseApiController
    before_action :authenticate_user!

    def index
      # """ 自身公開一覧が確認できる処理 """"
      # GET: http://localhost:3000/api/v1/current/articles

      articles = current_user.articles.where(status: 1).order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end
  end
end
