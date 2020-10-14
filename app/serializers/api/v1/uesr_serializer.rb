class Api::V1::UesrSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
end
