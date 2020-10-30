module Api::V1
  # base_api_controller を継承
  class ArticlesController < BaseApiController
    # Cheat CMD
    # $ bundle exec rails routes  | grep article
    #
    #   api_v1_articles GET    /api/v1/articles(.:format)       api/v1/articles#index
    #                   POST   /api/v1/articles(.:format)       api/v1/articles#create
    #
    #   api_v1_article GET    /api/v1/articles/:id(.:format)   api/v1/articles#show
    #                  PATCH  /api/v1/articles/:id(.:format)   api/v1/articles#update
    #                  PUT    /api/v1/articles/:id(.:format)   api/v1/articles#update
    #                  DELETE /api/v1/articles/:id(.:format)   api/v1/articles#destroy
    #

    def index
      # """ 記事の一覧を表示 """
      #  GET: http://localhost:3000/api/v1/articles.json
      #
      # 試した事
      # 　配列で値が入っている
      # 　>>> )> articles
      # 　=> [#<Article:0x00007f837ec4b6a8
      #   　id: 108,
      #   　title: "k5ncb2227rczx0dlvxyrf2i1mlsd5iprc424be3fay4ogpv",
      #   　body: "MyText",
      #   　user_id: 214,
      #   　created_at: Wed, 14 Oct 2020 22:46:32 UTC +00:00,
      #   　updated_at: Wed, 14 Oct 2020 22:46:32 UTC +00:00>,

      # 降順 sort: :desc
      articles = Article.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      # """ 記事の詳細をみる """
      #   GET: http://localhost:3000/api/v1/articles/2
      #
      # ExSample:
      #   pry(#<Api::V1::ArticlesController>))> params
      #   => <ActionController::Parameters {
      #     "controller"=>"api/v1/articles", "action"=>"show", "id"=>"2"} permitted: false>
      #
      #   pry(#<Api::V1::ArticlesController>)> article = Article.find(params[:id])
      #   Article Load (4.0ms)  SELECT "articles".* FROM "articles" WHERE "articles"."id" = $1 LIMIT $2  [["id", 2], ["LIMIT", 1]]
      #   ↳ (pry):10:in `show'
      #   => #<Article:0x00007f820e9125c0
      #   id: 2,
      #   title: "test=test=test",
      #   body: "mytextbody",
      #   user_id: 5,
      #   created_at: Sat, 10 Oct 2020 13:16:09 UTC +00:00,

      article = Article.find(params[:id])
      render json: article, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def create
      # """ 記事を作成する """
      #   POST: http://localhost:3000/api/v1/articles
      #
      # JSON ExSample
      # {
      #   "article": {
      #       "title": "title-title-title", # validates ... length: { in: 10..50 }
      #       "body": "body"
      #   }
      # }
      # -----------------------------------------------------
      #
      # article = current_user.article.create!(article_params)
      # >>> User >> has_many: article -> 複数系で書いてなかった
      # >>>                   articles に修正
      #
      # NoMethodError (undefined method `articles' for #<User:0x00007f9c7795c9d0>
      #   Did you mean?  article
      #                   article=):
      #
      #   app/controllers/api/v1/articles_controller.rb:81:in `create'

      # インスタンスを model から作成する
      # create!: new, saveを同時にしている: １行で処理を済ませる時は良い
      article = current_user.articles.create!(article_params)

      # json として値を返す
      render json: article
    end

    def update
      # """ 選択した記事を更新する """
      #   PATCH/PUT: http://localhost:3000/api/v1/articles/4
      #
      # Exsample ----------------------------------------------
      # user_id:2で, id:4 の記事を更新している。
      #
      # --- Send ---
      # Postman:/ ExSample:
      # {
      #   "article": {
      #     "title": "titil chenge ----------",
      #     "body": "change body ----"
      #   }
      # }
      # --- Response ---
      # {
      #   "user_id": 2,
      #   "id": 4,
      #   "title": "titil chenge ----------",
      #   "body": "change body ----",
      #   "created_at": "2020-10-20T13:42:44.892Z",
      #   "updated_at": "2020-10-25T06:40:52.971Z"
      # }
      # -------------------------------------------------------

      # 対象レコードを探す
      article = current_user.articles.find(params[:id])

      # 対象レコードを更新する
      article.update!(article_params)

      # 更新した値を json で返す
      render json: article
    end

    def destroy
      # """ 選択した記事を削除する  """
      #   DELETE http://localhost:3000/api/v1/articles/< article num >
      # ExSample: User.first を使用している

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
