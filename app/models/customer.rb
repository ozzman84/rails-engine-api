class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices
  # validates :first_name, :last_name, :created_at, :updated_at, presence: true
end
