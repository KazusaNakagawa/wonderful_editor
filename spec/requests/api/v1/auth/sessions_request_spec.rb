require "rails_helper"

# $ bundle exec rspec spec/requests/api/v1/auth/sessions_request_spec.rb --tag focus
RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "登録してるアカウントでログインした時" do
      # """ userを生成して, 登録user で login 認証している """
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: user.password) }

      it "ログインできる" do
        subject
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["uid"]).to be_present
        expect(response).to have_http_status(:ok)
      end
    end

    context "別 user: 登録されていないアカウントでログインした時" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user) }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "Invalid login credentials. Please try again."

        header = response.header
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "登録されたアカウント: passowrd が違う値でログインするとき" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: "xxxxx") }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "Invalid login credentials. Please try again."

        header = response.header
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "登録したアカウント: 登録していない email でログインした時" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: "xxx@xx.com", password: user.password) }

      it "ログインできない" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "Invalid login credentials. Please try again."

        header = response.header
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(header["uid"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers: headers) }

    context "auth token user がログアウトする時" do
      let(:user) { create(:user) }
      let!(:headers) { user.create_new_auth_token }

      it "トークンを無くし、ログアウトできる" do
        expect { subject }.to change { user.reload.tokens }.from(be_present).to(be_blank)
        expect(response).to have_http_status(:ok)
      end
    end

    context "auth tokenが付与されていない状態で, 送信した時" do
      let(:user) { create(:user) }
      let!(:token) { user.create_new_auth_token }
      # 明示的に空にしたことを書く
      let!(:headers) { { "access-token" => "", "token-type" => "", "client" => "", "expiry" => "", "uid" => "" } }
      # 同じ結果にはなる
      # let!(:headers) { {} }

      it "存在しないエラー" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to include "User was not found or was not logged in."
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
