require "rails_helper"

RSpec.describe User, type: :model do
  context "password を指定しているとき" do
    let(:user) { build(:user) }

    it "ユーザーが作られる" do
      expect(user).to be_valid
    end
  end

  context "password を指定していないとき" do
    let(:user) { build(:user, password: nil) }

    it "ユーザー作成に失敗する" do
      expect(user).to be_invalid
      expect(user.errors.details[:password][0][:error]).to eq :blank
    end
  end

  context "email を指定していないとき" do
    let(:user) { build(:user, email: nil) }

    it "ユーザー作成に失敗する" do
      expect(user).to be_invalid
      expect(user.errors.details[:email][0][:error]).to eq :blank
    end
  end

  context "まだ同じ名前の name が存在しないとき" do
    before { create(:user, name: "foo") }

    it "ユーザーが作られる" do
      user = build(:user, name: "bar")
      expect(user).to be_valid
    end
  end

  context "すでに同じ email が存在しているとき" do
    before { create(:user, email: "foo@foo.xxx") }

    it "ユーザー作成に失敗する" do
      user = build(:user, email: "foo@foo.xxx")
      expect(user).to be_invalid
      expect(user.errors.details[:email][0][:error]).to eq :taken
    end
  end
end
