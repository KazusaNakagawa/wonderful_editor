require "rails_helper"

RSpec.describe User, type: :model do
  context "password を指定しているとき" do
    it "ユーザーが作られる" do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  context "password を指定していないとき" do
    it "ユーザー作成に失敗する" do
      user = build(:user, password: nil)
      aggregate_failures "最後まで通過" do
        expect(user).to be_invalid
        expect(user.errors.details[:password][0][:error]).to eq :blank
      end
    end
  end

  context "email を指定していないとき" do
    it "ユーザー作成に失敗する" do
      user = build(:user, email: nil)
      aggregate_failures "最後まで通過" do
        expect(user).to be_invalid
        expect(user.errors.details[:email][0][:error]).to eq :blank
      end
    end
  end

  context "まだ同じ名前の name が存在しないとき" do
    it "ユーザーが作られる" do
    end
  end

  context "すでに同じ名前の name が存在しているとき" do
    it "ユーザー作成に失敗する" do
    end
  end
end
