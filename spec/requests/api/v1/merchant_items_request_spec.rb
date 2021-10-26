require 'rails_helper'

RSpec.describe 'MerchantItems', type: :request do
  describe 'Get all MerchantItems' do
    it 'Returns a Merchant\'s Items' do
      merch = Merchant.create(name: 'John')
      merch.items.create(name: 'stuff', description: 'things', unit_price: 39.99)
      get "/api/v1/merchants/#{merch.id}"
      merch_items = JSON.parse(response.body, symbolize_names: true)

      expect(merch_items[:data].count).to eq(3)
    end
  end
end
