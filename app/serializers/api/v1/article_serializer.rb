class Api::V1::ArticleSerializer < ActiveModel::Serializer
  # 詳細
  attributes :id, :title, :body, :status, :updated_at
  belongs_to :user, serializer: Api::V1::UserSerializer
end
