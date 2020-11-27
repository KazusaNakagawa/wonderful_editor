module Api::V1
  # base_api_controller を継承

  # before_action :article_params
  # before_action :authenticate_api_v1_user!, only: [:create, :update, :destory]
  # protect_from_forgery with: :null_session

  class ArticlesController < BaseApiController
    def index
      # """ 記事の一覧を表示 """
      #  GET: http://localhost:3000/api/v1/articles

      # 降順 sort: :desc
      articles = Article.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      # """ 記事の詳細をみる """
      #  GET: http://localhost:3000/api/v1/articles/2

      article = Article.find(params[:id])
      render json: article, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def create
      # """ 記事を作成する """
      #  POST: http://localhost:3000/api/v1/articles

      # インスタンスを model から作成する
      # create!: new, saveを同時にしている: １行で処理を済ませる時は良い
      article = current_user.articles.create!(article_params)
      # article = current_api_v1_user.articles.create!(article_params)

      # json として値を返す
      render json: article
    end

    def update
      # """ 選択した記事を更新する """
      #  PATCH/PUT: http://localhost:3000/api/v1/articles/:id

      # 対象レコードを探す
      article = current_user.articles.find(params[:id])

      # 対象レコードを更新する
      article.update!(article_params)

      # 更新した値を json で返す
      render json: article
    end

    def destroy
      # """ 選択した記事を削除する  """
      #   DELETE http://localhost:3000/api/v1/articles/:id

      # TODO：レコードがない時の処理
      # 対象レコードを探す
      article = current_user.articles.find(params[:id])

      # 記事を削除する
      article.destroy!

      # 更新した値を json で返す
      # render json: article
    end

    private

      def article_params
        # """ strong parameter """
        # 引数に修正可能な column を指定する
        params.require(:article).permit(:title, :body)
      end
  end
end
