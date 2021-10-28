class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  scope :search_all, ->(name) { where('name ILIKE ?', "%#{name}%").order(name: :desc) }
end
