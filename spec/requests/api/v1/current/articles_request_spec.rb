require "rails_helper"

# $ bundle exec rspec spec/requests/api/v1/current/articles_request_spec.rb --tag focus
RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers: headers) }

    context "ユーザを作成" do
      let(:current_user) { create(:user) }
      let(:headers) { current_user.create_new_auth_token }

      context "自身の公開記事一覧を確認する時" do
        # 公開記事を作成
        let!(:article1) { create(:article, :published, user: current_user, updated_at: 1.days.ago) }
        let!(:article2) { create(:article, :published, user: current_user, updated_at: 2.days.ago) }
        let!(:article3) { create(:article, :published, user: current_user) }

        it "閲覧できる" do
          subject
          res = JSON.parse(response.body)

          expect(res.length).to eq 3
          expect(res[0].keys).to eq ["id", "title", "status", "updated_at", "user"]
          expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
          expect(res[0]["user"].keys).to eq ["id", "name", "email"]
          expect(res[0]["status"]).to eq "published"

          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
