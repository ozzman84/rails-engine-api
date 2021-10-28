FactoryBot.define do
  ############### Customer ##################
  factory :customer, class: Customer do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
  end

############### Invoice Items ##################
  factory :invoice_item, class: InvoiceItem do
    quantity { Faker::Number.within(range: 1..100) }
    unit_price  { Faker::Number.within(range: 50..100000) }
    association :invoice, factory: :invoice
    association :item, factory: :item
  end

  factory :packaged_invoice_item, class: InvoiceItem do
    quantity { Faker::Number.within(range: 1..100) }
    unit_price  { Faker::Number.within(range: 50..100000) }
    # status { "packaged" }
    association :invoice, factory: :invoice
    association :item, factory: :item
    created_at {"2012-03-27 14:54:09 UTC"}
    updated_at {"2012-03-27 14:54:09 UTC"}
  end
  #
  factory :shipped_invoice_item, class: InvoiceItem do
    quantity { Faker::Number.within(range: 1..100) }
    unit_price  { Faker::Number.within(range: 50..100000) }
    # status {"shipped"}
    association :invoice, factory: :invoice
    association :item, factory: :item
    created_at {"2012-03-27 14:54:09 UTC"}
    updated_at {"2012-03-27 14:54:09 UTC"}
  end

  ############### Invoice  ##################
  factory :invoice, class: Invoice do
    status {"in progress"}
    association :customer, factory: :customer
    association :merchant, factory: :merchant
  end
  #
  # factory :cancelled_invoice, class: Invoice do
  #   status {"cancelled"}
  #   association :customer, factory: :customer
  #   created_at {"2012-03-27 14:54:09 UTC"}
  #   updated_at {"2012-03-27 14:54:09 UTC"}
  # end

  factory :completed_invoice, class: Invoice do
    status {"completed"}
    association :customer, factory: :customer
    created_at {"2012-03-27 14:54:09 UTC"}
    updated_at {"2012-03-27 14:54:09 UTC"}
  end

  ############### Items ##################
  factory :item, class: Item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    unit_price  { Faker::Number.within(range: 50..100000) }
    association :merchant, factory: :merchant
  end

  # ############### Merchant ##################
  # factory :merchant, class: Merchant do
  #   name { Faker::Commerce.brand }
  #   status {"enabled"}
  #   created_at {"2012-03-27 14:54:09 UTC"}
  #   updated_at {"2012-03-27 14:54:09 UTC"}
  # end

  # factory :disable_merchant, class: Merchant do
  #   name { Faker::Commerce.brand }
  #   status {"disabled"}
  #   created_at {"2012-03-27 14:54:09 UTC"}
  #   updated_at {"2012-03-27 14:54:09 UTC"}
  # end

  ############### Transactions ##################
  factory :transaction, class: Transaction do
    credit_card_number { Faker::Business.credit_card_number }
    result {"success"}
    association :invoice, factory: :invoice
  end

  factory :failed_transaction, class: Transaction do
    credit_card_number { Faker::Business.credit_card_number }
    result {"failed"}
    association :invoice, factory: :invoice
    created_at {"2012-03-27 14:54:09 UTC"}
    updated_at {"2012-03-27 14:54:09 UTC"}
  end

  ############### Merchants ##################
  factory :merchant, class: Merchant do
    name { Faker::Name.name}
  end
end
