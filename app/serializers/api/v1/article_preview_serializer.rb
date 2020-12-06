class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  # 値を返したい column を指定する
  attributes :id, :title, :status, :updated_at

  # userを関連付ける
  belongs_to :user, serializer: Api::V1::UserSerializer
end
