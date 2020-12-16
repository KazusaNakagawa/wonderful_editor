require "rails_helper"

# $ bundle exec rspec spec/requests/api/v1/articles/drafts_request_spec.rb --tag focus
RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /api/v1/articles/drafts" do
    subject { get(api_v1_articles_drafts_path, headers: headers) }

    context "ユーザを作成" do
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }

      context "自身の下書き一覧を確認する時" do
        # 記事を下書きで作成
        let!(:article1) { create(:article, :draft, user: current_user, updated_at: 1.days.ago) }
        let!(:article2) { create(:article, :draft, user: current_user, updated_at: 2.days.ago) }
        let!(:article3) { create(:article, :draft, user: current_user) }

        it "閲覧できる" do
          subject
          res = JSON.parse(response.body)

          expect(res.length).to eq 3
          expect(res[0].keys).to eq ["id", "title", "updated_at", "user"]
          expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
          expect(res[0]["user"].keys).to eq ["id", "name", "email"]
          expect(response).to have_http_status(:ok)
        end
      end

      context "他ユーザの下書き一覧を確認しようとした時" do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:other_user) { create(:user) }
        let(:token) { other_user.create_new_auth_token }
        # 記事作成
        let!(:article) { create(:article, :draft, user: other_user) }

        # """ 下書き記事を作成した後ログアウトする
        # まあ、他ユーザがログインしてても支障はなさそう
        # >>> rubocop: 退避コメントを入れて対応した
        # """
        let!(:other_user_headers) { { "access-token" => "", "token-type" => "", "client" => "", "expiry" => "", "uid" => "" } }

        it "閲覧できない" do
          subject
          res = JSON.parse(response.body)
          # 現在ログインしているuserか確認する
          expect(current_user.email).to eq headers["uid"]

          expect(res).to be_blank
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "GET /api/v1/articles/drafts/:id" do
    subject { get(api_v1_articles_draft_path(article_id), headers: headers) }

    context "ユーザを作成" do
      let(:headers) { current_user.create_new_auth_token }
      let(:current_user) { create(:user) }

      context "自身の指定した id の記事が存在する時" do
        let!(:article) { create(:article, :draft, user: current_user) }
        let(:article_id) { article.id }

        it "閲覧できる" do
          subject
          res = JSON.parse(response.body)
          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["status"]).to eq "draft"

          expect(response).to have_http_status(:ok)
        end
      end

      context "他ユーザの下書き詳細記事を閲覧しようとした時" do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:other_user) { create(:user) }
        let(:token) { other_user.create_new_auth_token }
        let(:article_id) { article.id }

        # 記事作成
        let!(:article) { create(:article, :draft, user: other_user) }
        let!(:other_user_headers) { { "access-token" => "", "token-type" => "", "client" => "", "expiry" => "", "uid" => "" } }

        it "閲覧できない" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
          expect(current_user.email).to eq headers["uid"]
        end
      end
    end
  end
end
