require "rails_helper"

# $ bundle exec rspec spec/requests/api/v1/articles/draft_request_spec.rb --tag focus
RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /draft" do
    context "自身の下書き一覧を確認する時" do
      it "閲覧できる" do
      end
    end
  end

  describe "GET /draft/:id" do
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
