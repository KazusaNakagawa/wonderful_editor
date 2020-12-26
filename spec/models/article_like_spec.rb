# == Schema Information
#
# Table name: article_likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_article_likes_on_article_id              (article_id)
#  index_article_likes_on_user_id                 (user_id)
#  index_article_likes_on_user_id_and_article_id  (user_id,article_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  context "記事が存在している時" do
    let(:article_like) { create(:article_like) }

    it "いいねできる" do
      expect(article_like).to be_valid
    end
  end

  context "記事が存在しない時" do
    # let(:article_like) { build(:article_like) }
    # """ 確認できる
    # article_like.article
    # article_like.user
    # """

    it "いいねできない" do
      # binding.pry
      # expect(article_like).to be_invalid
      # expect(article_like.errors.messages[:article][0]).to eq "must exist"
    end
  end
end
