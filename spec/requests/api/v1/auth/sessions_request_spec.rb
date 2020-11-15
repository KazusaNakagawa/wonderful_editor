require "rails_helper"

# $ bundle exec rspec spec/requests/api/v1/auth/sessions_request_spec.rb --tag focus
RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sing_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "登録してるアカウントでログインした時" do
      # """ userを生成して, 登録user で login 認証している """
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: user.password) }

      it "login success" do
        subject
        header = response.header
        expect(header["access-token"]).to be_present
        expect(header["client"]).to be_present
        expect(header["expiry"]).to be_present
        expect(header["uid"]).to eq user.email
        expect(response).to have_http_status(:ok)
      end
    end

    context "登録されていないアカウントでログインした時" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user) }

      it "do Error" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"][0]).to eq "Invalid login credentials. Please try again."
        header = response.header
        expect(header["access-token"]).not_to be_present
        expect(header["client"]).not_to be_present
        expect(header["expiry"]).not_to be_present
        expect(header["uid"]).not_to eq be_present
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "登録されたアカウント: passowrd が違う値で login した時" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: "xxxxx") }

      it "do Error" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"][0]).to eq "Invalid login credentials. Please try again."
        header = response.header
        expect(header["access-token"]).not_to be_present
        expect(header["client"]).not_to be_present
        expect(header["expiry"]).not_to be_present
        expect(header["uid"]).not_to eq be_present
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "登録したアカウント: email が存在しない値で login した時" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: "xxx@xx.com", password: user.password) }

      it "do Error" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"][0]).to eq "Invalid login credentials. Please try again."
        header = response.header
        expect(header["access-token"]).not_to be_present
        expect(header["client"]).not_to be_present
        expect(header["expiry"]).not_to be_present
        expect(header["uid"]).not_to be_present
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
