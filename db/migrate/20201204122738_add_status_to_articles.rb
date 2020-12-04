class AddStatusToArticles < ActiveRecord::Migration[6.0]
  def change
    # after: <column name>  ->> MySQLのみ, Postgres, sqliteは末尾に反映される
    add_column :articles, :status, :integer, null: false, default: 0, after: :body
  end
end
