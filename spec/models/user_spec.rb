# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  status                 :integer          default("archived"), not null
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
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
