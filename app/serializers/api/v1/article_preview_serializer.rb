class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  # 一覧 column を指定する
  attributes :id, :title, :updated_at

  # userを関連付ける
  belongs_to :user, serializer: Api::V1::UserSerializer
end
