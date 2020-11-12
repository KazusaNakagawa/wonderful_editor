require "rails_helper"

# $ bundle exec rspec spec/requests/api/v1/auth/sessions_request_spec.rb --tag focus
RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/:id" do
    subject { post(api_v1_user_session_path, params: params) }

    context "登録してるアカウントでログインする時" do
      let(:params) { attributes_for(:user) }

      it "login success" do
        subject
      end
    end

    context "登録されていないアカウントでログインしようとする時" do
      let(:params) { attributes_for(:user) }

      it "do Error" do
        subject
      end
    end
  end
end
