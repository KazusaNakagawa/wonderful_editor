require "rails_helper"

# $ bundle exec rspec spec/requests/api/v1/auth/registrations_request_spec.rb --tag focus

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "新規登録 response header 情報が正しい時" do
      # """ 正確な header 情報（トークン）のレスポンスを確認する """

      let(:params) { attributes_for(:user) }

      # 新規登録画面に必要な情報を入力して返ってきた情報の一部
      let(:token) { response.headers["access-token"] }
      let(:uid) { response.headers["uid"] }

      it "新規登録ができる" do
        subject
        expect(token).not_to be_nil
        expect(uid).to eq params[:email]
        expect(response).to have_http_status(:ok)
      end
    end

    context "新規登録するUser情報が正しい時" do
      # """ このテストはただ, リクエスト情報の確認をしてるだけ """
      let(:params) { attributes_for(:user, password: 123456, password_confirmation: 123456) }

      it "新規登録ができる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["data"]["id"]).to eq User.last.id
        expect(res["data"]["email"]).to eq User.last.email
        expect(res["data"]["name"]).to eq params[:name]
      end
    end

    context "新規登録するUserのpass認証が違う時" do
      let(:params) { attributes_for(:user, password: 123456, password_confirmation: 123457) }

      it "do Error" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "新規登録するUserのEmailがすでに登録されている時" do
      let!(:user) { create(:user, email: "Exsample@xxx.com") }
      let(:params) { attributes_for(:user, email: "Exsample@xxx.com") }

      it "do Error" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
