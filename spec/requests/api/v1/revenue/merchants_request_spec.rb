require 'rails_helper'

RSpec.describe 'Revenue', type: :request do
  describe 'Merchants with Most Revenue' do
    context 'When given a correct query' do
      before { get '/api/v1/revenue/merchants?quantity=10' }

      it 'Merchant count matches query' do
        expect(json[:data].size).to eq(10)
      end
    end
  end
end
