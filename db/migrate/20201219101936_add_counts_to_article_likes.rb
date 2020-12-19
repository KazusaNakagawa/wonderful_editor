class AddCountsToArticleLikes < ActiveRecord::Migration[6.0]
  def change
    add_column :article_likes, :count, :integer, null: false, default: 0, after: :id
  end
end
