# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :integer          default("drafts"), not null
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
class Article < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { in: 10..50 }

  has_many :article_likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum status: { drafts: 0, publish: 1 }
end
