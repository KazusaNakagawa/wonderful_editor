require "rails_helper"

# CheatCMD
#   $ bundle exec rspec spec/requests/api/v1/articles_spec.rb --tag focus

# type: request の test をするので :requestとする
RSpec.describe "Api::V1::Articles", type: :request do
  # test対象のurl
  describe "GET /articles" do
    # status 200 の確認　
    subject { get(api_v1_articles_path) }

    # updated_at 引数設定は, descを確かめるため
    # この書き方はしない >>> let!(:article) { create_list(:article, 3) }
    # let! =>配下より先に処理される
    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article) }

    it "記事一覧が表示できる" do
      # >>> console sample
      # いろいろ試す事ができる
      #
      # res.map {|d| d["user"]["id"] }
      # => [320, 317, 316]
      #
      # article1
      # => #<Article:0x00007fed2f5a0360
      #  id: 195,
      #  title: "tmnknwaseiftocgigmdguio4pspfdw6s5h7rb4pbgnuff7",
      #  body: "出かけるむこう割り箸むらさきいろ。",
      #  user_id: 318,
      #  created_at: Fri, 16 Oct 2020 21:53:59 UTC +00:00,
      #  updated_at: Thu, 15 Oct 2020 21:53:59 UTC +00:00>
      #
      # expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      # => true
      #
      # res
      # => [{"id"=>197,
      #   "title"=>"1yjy58z6qpjtl5il6rg3kiyr6p8r1",
      #   "updated_at"=>"2020-10-16T21:54:00.962Z",
      #   "user"=>{"id"=>320, "name"=>"野村 彩乃", "email"=>"14_leopoldo_weber@parisian.com"}},
      #  {"id"=>194,
      #   "title"=>"4rhfuzp29i9wnnetn4",
      #   "updated_at"=>"2020-10-16T21:53:59.165Z",
      #   "user"=>{"id"=>317, "name"=>"林 匠", "email"=>"11_shu@ryan-breitenberg.net"}},
      #  {"id"=>193,
      #   "title"=>"sn9un5jypo90w",
      #   "updated_at"=>"2020-10-16T21:53:58.671Z",
      #   "user"=>{"id"=>316, "name"=>"金子 優斗", "email"=>"10_solange.schulist@littel.biz"}},]
      #
      # res[0]
      # => {"id"=>197,
      #  "title"=>"1yjy58z6qpjtl5il6rg3kiyr6p8r1",
      #  "updated_at"=>"2020-10-16T21:54:00.962Z",
      #  "user"=>{"id"=>320, "name"=>"野村 彩乃", "email"=>"14_leopoldo_weber@parisian.com"}}

      subject
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end

  describe "GET /articles/:id" do
    # 1: article_id を探す
    subject { get(api_v1_article_path(article_id)) }

    context "指定した id の記事が存在する場合" do
      # 3: ここの articleを辿る
      let(:article) { create(:article) }
      # 2: article を探す
      let(:article_id) { article.id }

      it "指定したid の記事を表示できる" do
        subject
        res = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(res.keys).to eq ["id", "title", "body", "user_id", "created_at", "updated_at"]

        # 4: article.xx を明記
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["user_id"]).to eq article.user_id

        # be_xxx: matcher
        expect(res["updated_at"]).to be_present
      end
    end

    context "指定した id の記事が存在しない場合" do
      let(:article_id) { Article.last&.id.to_i + 1 }

      it "指定したid の記事が表示できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /articles" do
    # 2: 定義
    #   params: xxx
    #     xxx: >>> 送りたい値
    # 記事を作成する動作を確認
    subject { post(api_v1_articles_path, params: params) }

    context "login している user で記事を作成する時" do
      # 3: subject から呼ばれる
      #
      # attributes_for(:xxx) >>> FactoryBotで定義した :xxx をもとにパラメータを再生できる
      #   [2] pry(RSpec::ExampleGroups::ApiV1Articles::POSTArticles::LogInUser)
      #   > FactoryBot.attributes_for(:article)
      #   => {
      #       :title=>"rehjdlj9l4fomuhpd4p2e4uzh2s31ok",
      #       :body=>"交錯済ます人口金。"
      #     }
      # 3-1
      #   Api::V1::ArticlesController#article_params
      #   >> この中の params.reqire(:article)の :article を key として渡す
      let(:params) { { article: attributes_for(:article) } }

      # 3-2
      # ExSample
      #   > current_user
      #   => #<User
      #       id: 440,
      #       provider: "email",
      #       uid: "1_levi_schowalter@lakin.info",
      #       allow_password_change: false,
      #       name: "竹内 翔",
      #       image: nil,
      #       email: "1_levi_schowalter@lakin.info",
      #       created_at: "2020-10-24 00:35:36",
      #       updated_at: "2020-10-24 00:35:36">
      # FactoyBotでuserを作成: 変数を currnt_user_stub
      let!(:current_user_stub) { create(:user) }

      # stub: 外部APIに依存されないようにする
      # before: 事前に処理するものをかく: 今回でいうとログインされたuserを装う
      before do
        # ここでcurrent_userメソッドが呼ばれたら上で作った:currrent_userを返すように実装を上書き

        allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_stub) # rubocop:disable all

        # allow(実装を置き換えたいオブジェクト).to receive(置き換えたいメソッド名).and_return(返却したい値やオブジェクト)
        #                                                      ↓ここで上書き　　　　　　　　↓ここは上で作った変数
        # allow(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_stub)

        # >>> 上手くいかない
        #     1) Api::V1::Articles POST /articles login している user で記事を作成する時 記事が作成できる
        #           Api::V1::BaseApiController does not implement: current_user
        #     ./spec/requests/api/v1/articles_spec.rb:154:in `block (4 levels) in <main>'
      end

      it "記事が作成できる" do
        # 1:実際の処理
        expect { subject }.to change { Article.count }.by(1)
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res.keys).to eq ["id", "title", "body", "user_id", "created_at", "updated_at"]
        expect(res["user_id"]).to eq current_user_stub.id
        expect(res["title"]).to eq params[:article][:title]
        expect(res["body"]).to eq params[:article][:body]
      end
    end

    # TODO: 検証保留 2020/10/25
    context "login していない user が記事作成しようとする時" do
      it "do Error" do
      end
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    # 定義
    # 1.article_id: 記事No >>> params を探す
    subject { patch(api_v1_article_path(article.id), params: params) }

    # ここから　-----------------------------------------------
    # 2.paramsの定義 >>> articleを探す
    let(:params) { { article: attributes_for(:article) } }

    # 3.articleの定義 >>> currnt_user_stubを探す
    let(:article) { create(:article, user: current_user_stub) }

    # 4.user生成
    let(:current_user_stub) { create(:user) }

    # 5.stub ログインしたUserを擬似的に生成 >>> currnt_user とする
    before do
      allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user_stub) # rubocop:disable all
    end
    # ここまで　-----------------------------------------------

    context "ログインしたuserが自身の記事を更新しようとする時" do
      # 記事のtitle, bodyを更新
      it "更新できる" do
        # X を A から B に
        # expect { subject }.to change { X }.from(A).to(B)
        # subjectは1回のみしか呼べない?? >>> 1回呼び出されたら、キャッシュが効いているから
        #
        # どちらの記述も同じ値が返ってくる??　謎
        # artcle.title        : >> "title-title" -> String
        # artcle.reload.title : >> "title-title" -> String
        # reload: この記述にすることで 記事のデータを DB から再取得すると
        expect { subject }.to change { article.reload.title }.from(article.title).to(params[:article][:title]) &
                              change { article.reload.body }.from(article.body).to(params[:article][:body])
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログインしたuserが他人の記事を更新しようとした時" do
      # user生成
      let(:other_user) { create(:user) }
      # 先呼び出ししないとErrorする recode数の確認のところでerrorはく
      let!(:article) { create(:article, user: other_user) }

      it "更新出来ない" do
        # Error, recode数に変化ないことを確認している
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound) &
                              change { Article.count }.by(0)
      end
    end
  end

  describe "DELETE /articles/:id" do
    it "指定したレコードを削除できる" do
    end
  end
end
