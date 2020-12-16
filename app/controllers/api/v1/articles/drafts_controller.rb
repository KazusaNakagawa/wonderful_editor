module Api::V1
  class Articles::DraftsController < BaseApiController
    before_action :authenticate_user!

    def index
      # """ 自身の下書き一覧が確認できる処理 """"
      # GET: http://localhost:3000/api/v1/articles/draft

      articles = current_user.articles.draft.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      # """ 自身の下書き１レコードが確認できる処理 """
      # GET: http://localhost:3000/api/v1/articles/draft/:id

      article = current_user.articles.draft.find(params[:id])
      render json: article, serializer: Api::V1::ArticleSerializer
    end
  end
end
