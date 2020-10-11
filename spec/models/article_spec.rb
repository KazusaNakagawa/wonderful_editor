# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  context "titleがある時" do
    let(:article) { create(:article) }
    it "記事を投稿できる" do
      expect(article).to be_valid
    end
  end

  context "title が 10文字より少ない時" do
    let(:article) { build(:article, title: "*" * 9) }
    it "記事の投稿に失敗する" do
      expect(article).to be_invalid
      expect(article.errors.details[:title][0][:error]).to eq :too_short
    end
  end

  context "title が 50文字より多い時" do
    let(:article) { build(:article, title: "*" * 51) }
    it "記事の投稿に失敗する" do
      expect(article).to be_invalid
      expect(article.errors.details[:title][0][:error]).to eq :too_long
    end
  end

  context "titleがない時" do
    let(:article) { build(:article, title: nil) }
    it "記事の投稿に失敗する" do
      expect(article).to be_invalid
      expect(article.errors.details[:title][0][:error]).to eq :blank
      expect(article.errors.details[:title][1][:error]).to eq :too_short
    end
  end
end
