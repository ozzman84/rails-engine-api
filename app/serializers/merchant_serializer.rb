class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name
  # has_many :items, dependent: :destroy
  # has_many :invoices, through: :items
end
