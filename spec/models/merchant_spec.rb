require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:invoices).through :items }
    it { should have_many(:invoice_items).through :items }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'instance methods' do
    before :each do
      @merch = create_list(:merchant, 7)
      @item1 = create(:item, merchant: @merch[0])
      @item2 = create(:item, merchant: @merch[0])
      @item3 = create(:item, merchant: @merch[0])
      @item4 = create(:item, merchant: @merch[1])
      @item5 = create(:item, merchant: @merch[2])
      @item6 = create(:item, merchant: @merch[3])
      @item7 = create(:item, merchant: @merch[4])
      @item8 = create(:item, merchant: @merch[5])
      @item9 = create(:item, merchant: @merch[6])
      @invoice = create(:invoice, updated_at: "2012-03-26 09:54:09")
      @invoice1 = create(:invoice, updated_at: "2012-03-25 09:54:09")
      @invoice2 = create(:invoice, updated_at: "2012-03-25 09:54:09")
      @invoice3 = create(:invoice, updated_at: "2012-03-25 09:54:09")
      @invoice4 = create(:invoice, updated_at: "2012-03-25 09:54:09")
      @invoice5 = create(:invoice, updated_at: "2012-03-25 09:54:09")
      @invoice6 = create(:invoice, updated_at: "2012-03-25 09:54:09")
      @invoice7 = create(:invoice, updated_at: "2012-03-25 09:54:09")
      @invoice8 = create(:invoice, updated_at: "2012-03-25 09:54:09")
      @inv_item1 = create(:invoice_item, invoice: @invoice, item: @item1, unit_price: 2000, quantity: 1)
      @inv_item2 = create(:packaged_invoice_item, invoice: @invoice, item: @item1, unit_price: 1000, quantity: 1)
      @inv_item3 = create(:invoice_item, invoice: @invoice1, item: @item2, unit_price: 1000, quantity: 1)
      @inv_item4 = create(:shipped_invoice_item, invoice: @invoice1, item: @item2, unit_price: 1000, quantity: 1)
      @inv_item5 = create(:invoice_item, invoice: @invoice2, item: @item4, unit_price: 1000, quantity: 1)
      @inv_item6 = create(:invoice_item, invoice: @invoice3, item: @item5, unit_price: 2000, quantity: 2)
      @inv_item7 = create(:invoice_item, invoice: @invoice4, item: @item6, unit_price: 3000, quantity: 1)
      @inv_item8 = create(:invoice_item, invoice: @invoice5, item: @item6, unit_price: 2500, quantity: 2)
      @inv_item9 = create(:invoice_item, invoice: @invoice5, item: @item7, unit_price: 1500, quantity: 2)
      @inv_item10 = create(:invoice_item, invoice: @invoice5, item: @item8, unit_price: 3500, quantity: 2)
      @inv_item11 = create(:invoice_item, invoice: @invoice6, item: @item9, unit_price: 3000, quantity: 3)
      @inv_item13 = create(:invoice_item, invoice: @invoice8, item: @item3, unit_price: 3000, quantity: 3)
      @transaction = create(:transaction, invoice: @invoice)
      @transaction2 = create(:transaction, invoice: @invoice1)
      @transaction3 = create(:transaction, invoice: @invoice2)
      @transaction4 = create(:transaction, invoice: @invoice3)
      @transaction5 = create(:transaction, invoice: @invoice4)
      @transaction6 = create(:transaction, invoice: @invoice5)
      @transaction7 = create(:failed_transaction, invoice: @invoice6)
      @transaction8 = create(:failed_transaction, invoice: @invoice4)
    end

    describe 'Find Merchant by name' do
      it 'returns a Merchant by name' do
        expect(Merchant.find_with_name(@merch[3].name)).to eq([@merch[3]])
      end
    end

    describe 'Merchants ordered by Revenue' do
      it 'returns top 5 merchants by revenue' do
        expect(Merchant.desc_total_rev(5)).to eq([@merch[3], @merch[5], @merch[0], @merch[2], @merch[4]])
      end
    end

    describe 'Merchants ordered by Items sold' do
      it 'returns top 5 merchants by Items sold' do
        result = [@merch[0], @merch[3], @merch[2], @merch[4], @merch[5]]

        expect(Merchant.desc_most_items_sold(5)).to eq(result)
      end
    end

    describe 'Merchants ordered by Revenue' do
      it 'returns top 5 merchants by revenue' do
        expect(Merchant.total_rev(@merch[0].id)).to eq(@merch[0])
      end
    end
  end
end
