require "rails_helper"

# $ bundle exec rspec spec/requests/api/v1/auth/registrations_request_spec.rb --tag focus

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "POST /api/v1/auth" do
    subject { post(api_v1_user_registration_path, params: params) }

    context "新規登録するUser情報が正しい時" do
      let(:params) { attributes_for(:user) }

      it "新規登録ができる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["data"]["id"]).to eq User.last.id
        expect(res["data"]["email"]).to eq User.last.email
        expect(res["data"]["name"]).to eq params[:name]
      end
    end

    # context "新規登録するUserのpass認証が違う時" do
    #   it "do Error" do
    #   end
    # end

    # context "新規登録するUserのEmailがすでに登録されている時" do
    #   it "do Error" do
    #   end
    # end
  end
end
