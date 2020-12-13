module Api::V1
  class Articles::DraftController < BaseApiController
    before_action :authenticate_user!

    def index
      # """ 自身の下書き一覧が確認できる処理 """"
      # GET: http://localhost:3000/api/v1/articles/draft

      articles = current_user.articles.where(status: 0).order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      # """ 自身の下書き１レコードが確認できる処理 """
      # GET: http://localhost:3000/api/v1/articles/draft/:id

      article = current_user.articles.find(params[:id])

      # TODO: 登録されていないレコードが指定された時, Not Found で返すメッセージ

      # 公開記事が指定された場合は Not Found で返す
      if article["status"] == "published"
        response.status = 404
        render json: 404
      end

      # 下書き指定記事のみ表示
      if article["status"] == "draft"
        render json: article, each_serializer: Api::V1::ArticlePreviewSerializer
      end
    end
  end
end
