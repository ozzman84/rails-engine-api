require 'rails_helper'

RSpec.describe 'Revenue', type: :request do
  describe 'Merchants with Most Revenue' do
    let!(:merchants) { create_list(:merchant, 20) }
    let(:items) { create_list(:item, 100) }
    let(:invoice_items) { create_list(:invoice_item, 100) }
    let(:invoices) { create_list(:invoice, 100) }
    let(:transactions) { create_list(:transaction, 100) }
    before { get api_v1_merchants_path }

    it 'Sends list of Merchants' do
      expect(response).to be_successful

      expect(json).to be_a Hash
      expect(json[:data]).to be_a Array

      expect(json[:data][0].keys).to match_array(%i[attributes id type])
      expect(json[:data][0][:id]).to be_an(String)
      expect(json[:data][0][:type]).to eq 'merchant'

      expect(json[:data][0][:attributes]).to have_key :name
      expect(json[:data][0][:attributes][:name]).to be_a String
      expect(json[:data][0][:attributes]).to_not have_key :created_at
      expect(json[:data][0][:attributes]).to_not have_key :updated_at
      expect(json[:data][0][:attributes]).to_not have_key :cohort_id
    end

    context 'When given a correct query' do
      before { get '/api/v1/revenue/merchants?quantity=10' }

      it 'Merchant count matches query' do
        get '/api/v1/revenue/merchants?quantity=10'
        binding.pry
        expect(json[:data].size).to eq(10)
      end
    end
  end
end
