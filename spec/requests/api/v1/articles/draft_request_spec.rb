require "rails_helper"

# $ bundle exec rspec spec/requests/api/v1/articles/draft_request_spec.rb --tag focus
RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /api/v1/articles/draft" do
    subject { get(api_v1_articles_draft_index_path, headers: headers) }

    # 登録Userでログイン
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
        expect(res[0].keys).to eq ["id", "title", "status", "updated_at", "user"]
        expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
        expect(res[0]["status"]).to eq "draft"
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET  /api/v1/articles/draft/:id" do
    subject { get(api_v1_articles_draft_path(article_id)) }

    context "自身の指定した id の記事が存在する時" do
      it "閲覧できる" do
      end
    end

    context "自身の指定した id の記事が存在しない時" do
      it "Not Found で返す" do
      end
    end

    context "他のアカウントで下書き記事を表示させようとした時" do
      it "記事が表示できない" do
      end
    end
  end
end
