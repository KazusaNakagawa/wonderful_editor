# == Schema Information
#
# Table name: article_likes
#
#  id         :bigint           not null, primary key
#  like_count :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_article_likes_on_article_id  (article_id)
#  index_article_likes_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  context "記事が存在している時" do
    it "いいねをクリックできる" do
    end
  end
end
