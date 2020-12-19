class AddLikeCountToArticleLikes < ActiveRecord::Migration[6.0]
  def change
    add_column :article_likes, :like_count, :integer, null: false, default: 0, after: :id
  end
end
