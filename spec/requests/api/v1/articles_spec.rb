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
    subject { post(api_v1_articles_path, params: params) }

    context "login している user で記事を作成する時" do

      # 3: subject から呼ばれる
      #   ref: https://qiita.com/morrr/items/f1d3ac46b029ccddd017#db%E3%81%B8%E3%81%AE%E4%BF%9D%E5%AD%98%E7%8A%B6%E6%85%8B%E3%82%92%E5%A4%89%E3%81%88%E3%81%A6%E7%94%9F%E6%88%90%E3%81%99%E3%82%8Bbuildbuild_stubbedcreateattributes_for
      #
      # attributes_for(:xxx) >>> FactoryBotで定義した :xxx をもとにパラメータを再生できる
      #   [2] pry(RSpec::ExampleGroups::ApiV1Articles::POSTArticles::LogInUser)
      #   > FactoryBot.attributes_for(:article)
      #   => {:title=>"rehjdlj9l4fomuhpd4p2e4uzh2s31ok", :body=>"交錯済ます人口金。"}
      #
      # 3-1
      #   Api::V1::ArticlesController#article_params
      #   >> この中の params.reqire(:article)の :article を key として渡す
      let(:params) { { article: attributes_for(:article) } }
      binding.pry
      # 3-2
      #   > current_user
      #   => #<User id: 440, provider: "email", uid: "1_levi_schowalter@lakin.info", allow_password_change: false, \
      #   name: "竹内 翔", image: nil, email: "1_levi_schowalter@lakin.info",
      #   created_at: "2020-10-24 00:35:36", updated_at: "2020-10-24 00:35:36">
      let(:current_user) { create(:user) }


      # stub: 外部APIに依存されないようにする
      # allow().to receive(:twitter_client).and_return(current_user)


      fit "記事が作成できる" do
        # 1:実際の処理
        expect { subject }.to change { Article.count }.by(1)
        # expect { subject }.to change { User.count }.by(1)
        binding.pry
        # res = JSON.parse(response.body)
        # binding.pry
        # allow(current_user).to receive(:update)

        # userがいない
        #[1] pry(#<RSpec::ExampleGroups::ApiV1Articles::POSTArticles::LogInUser>)> params
        # => {:title=>"803tkwz0hc9ngockjy4339bqdvqi66m5ko0j", :body=>"まほうつかいぶん脱税壮年。"}
      end
    end

    context "login していない user が記事作成する時" do
      it "記事が作成できない" do

      end
    end
  end
end
