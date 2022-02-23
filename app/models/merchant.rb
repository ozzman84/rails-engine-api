class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoices, through: :items
  has_many :invoice_items, through: :items

  validates :name, presence: true

  scope :find_with_name, ->(name) { where('name ILIKE ?', "%#{name}%") }

  scope :desc_total_rev, ->(quantity) {
    joins(invoices: :transactions)
    .where('transactions.result = ?', 'success')
    .select('merchants.*, SUM(invoice_items.unit_price*invoice_items.quantity) AS revenue')
    .group(:id)
    .order(revenue: :desc)
    .limit(quantity)
  }

  scope :desc_most_items_sold, ->(quantity) {
    joins(invoices: :transactions)
    .where(transactions: { result: 'success' })
    .select('merchants.*, SUM(invoice_items.quantity) AS item_count')
    .group(:id)
    .order(item_count: :desc)
    .limit(quantity)
  }

  scope :total_rev, ->(id) {
    joins(invoices: :transactions)
    .where(transactions: { result: 'success' })
    .where(id: id)
    .select('merchants.*, SUM(invoice_items.unit_price*invoice_items.quantity) AS revenue')
    .group(:id)
    .first
  }
end
