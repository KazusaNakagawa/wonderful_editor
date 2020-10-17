require "rails_helper"

# type: request の test をするにで :requestとする
RSpec.describe "Api::V1::Articles", type: :request do
  # test対象のurl
  describe "GET /article" do
    # status 200 の確認　
    subject { get(api_v1_articles_path) }

    # updated_at 引数設定は, descを確かめるため
    # この書き方はしない >>> let!(:article) { create_list(:article, 3) }
    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article) }

    it "記事一覧が表示できる" do
      # =begin
      # >>> console sample
      # いろいろ試す事ができる

      # res.map {|d| d["user"]["id"] }
      # => [320, 317, 316]

      # article1
      # => #<Article:0x00007fed2f5a0360
      #  id: 195,
      #  title: "tmnknwaseiftocgigmdguio4pspfdw6s5h7rb4pbgnuff7",
      #  body: "出かけるむこう割り箸むらさきいろ。",
      #  user_id: 318,
      #  created_at: Fri, 16 Oct 2020 21:53:59 UTC +00:00,
      #  updated_at: Thu, 15 Oct 2020 21:53:59 UTC +00:00>

      # expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      # => true

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

      # res[0]
      # => {"id"=>197,
      #  "title"=>"1yjy58z6qpjtl5il6rg3kiyr6p8r1",
      #  "updated_at"=>"2020-10-16T21:54:00.962Z",
      #  "user"=>{"id"=>320, "name"=>"野村 彩乃", "email"=>"14_leopoldo_weber@parisian.com"}}

      # =end

      subject
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
    end
  end
end
