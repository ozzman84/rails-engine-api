class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, through: :items
  # validates :name, presence: true

  # scope :desc_rev, ->(quantity) { invoices.joins(:transactions)
  #   .where('transactions.result = ?', 1)
  #   .select('merchants.*, SUM(invoice_items.unit_price*invoice_items.quantity) AS total_rev')
  #   .group(:id)
  #   .order(total_rev: :desc)
  #   .limit(quantity)
  # }
end
