require 'rails_helper'

RSpec.describe "Merchants", type: :request do
  describe 'Get all Merchants' do
    let!(:all_merch) { create_list(:merchant, 100) }
    let(:merch1_id) { all_merch[0].id }
    let(:merch20_id) { all_merch[20].id }
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

    describe 'Paginated Merchants' do
      it 'No input returns 20 Merchant' do
        get '/api/v1/merchants?'

        expect(json[:data].count).to eq(20)
        expect(json[:data][0][:id]).to eq(merch1_id.to_s)
      end

      it 'fetching page 1 is the same list of first 20 in db' do
        get '/api/v1/merchants?per_page=20&page=1'

        expect(json[:data].count).to eq(20)
        expect(json[:data][0][:id]).to eq(merch1_id.to_s)
      end

      it 'fetching page -1 is the same list of first 20 in db' do
        get '/api/v1/merchants?page=-1'

        expect(json[:data].count).to eq(20)
        expect(json[:data][0][:id]).to eq(merch1_id.to_s)
      end

      it 'happy path, fetch second page of 20 merchants' do
        get '/api/v1/merchants?per_page=20&page=2'

        expect(json[:data].count).to eq(20)
        expect(json[:data][0][:id]).to eq(merch20_id.to_s)
      end

      it 'fetch first page of 50 merchants' do
        get '/api/v1/merchants?per_page=50'

        expect(json[:data].count).to eq(50)
      end

      it 'fetch all merchants if per page is really big' do
        get '/api/v1/merchants?per_page=100'

        expect(json[:data].count).to eq(all_merch.count)
      end
    end

    describe 'Get one Merchant' do
      it 'can get merchant by id' do
        id = create(:merchant).id
        get "/api/v1/merchants/#{id}"

        expect(response).to be_successful
        expect(json[:data][:id]).to eq(id.to_s)
      end

      context 'when the record does not exist' do
        let(:merchant_id) { Merchant.last.id + 1 }
        before { get "/api/v1/merchants/#{merchant_id}" }

        it 'returns status code 404' do
          get "/api/v1/merchants/#{merchant_id}"

          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe 'With no Merchant data' do
    it 'returns empty array' do
      get '/api/v1/merchants?per_page=20&page=2'

      expect(json[:data].count).to eq(0)
      expect(json[:data]).to eq([])
    end
  end
end
