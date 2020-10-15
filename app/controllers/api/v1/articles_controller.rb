module Api::V1
  # base_api_controller を継承
  class ArticlesController < BaseApiController
    def index
      # =begin
      #   試した事
      #   配列で値が入っている
      #   >>> )> articles
      #   => [#<Article:0x00007f837ec4b6a8
      #     id: 108,
      #     title: "k5ncb2227rczx0dlvxyrf2i1mlsd5iprc424be3fay4ogpv",
      #     body: "MyText",
      #     user_id: 214,
      #     created_at: Wed, 14 Oct 2020 22:46:32 UTC +00:00,
      #     updated_at: Wed, 14 Oct 2020 22:46:32 UTC +00:00>,
      #   #<Article:0x00007f837ec4b590
      #     id: 106,
      #     title: "fpwf2mes22u3bte9ulknepp2j8x",
      #     body: "MyText",
      #     user_id: 212,
      #     created_at: Wed, 14 Oct 2020 22:46:31 UTC +00:00,
      #     updated_at: Tue, 13 Oct 2020 22:46:30 UTC +00:00>,]
      # =end
      # 降順 sort: :desc
      articles = Article.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end
  end
end
