require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/:id" do
    subject { post(api_v1_user_session_path, params: params) }

    context "登録してるアカウントでログインする時" do
      it "login succeeds" do
      end
    end

    context "登録されていないアカウントでログインしようとする時" do
      it "do Error" do
      end
    end
  end
end
