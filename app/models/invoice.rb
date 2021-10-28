class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  validates :status, presence: true

  scope :unshipped_rev, ->(quantity = 10) {
    joins(:invoice_items)
    .where(status: 'packaged')
    .select('invoices.*, SUM(invoice_items.unit_price*invoice_items.quantity) AS potential_revenue')
    .group(:id)
    .order(potential_revenue: :desc)
    .limit(quantity)
  }
end
