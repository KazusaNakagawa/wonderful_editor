class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  # 一覧表示に指定する column
  attributes :id, :title, :updated_at

  # userを関連付ける
  belongs_to :user, serializer: Api::V1::UserSerializer
end
