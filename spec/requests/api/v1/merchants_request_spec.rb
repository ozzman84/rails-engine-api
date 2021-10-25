require 'rails_helper'

RSpec.describe "Merchants", type: :request do
  describe 'Get all Merchants' do
    before :each do
      @all_merch = create_list(:merchant, 100)
    end
    before { get api_v1_merchants_path }

    it 'Sends list of Merchants' do
      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants).to be_a Hash
      expect(merchants[:data]).to be_a Array

      expect(merchants[:data][0].keys).to match_array(%i[attributes id type])
      expect(merchants[:data][0][:id]).to be_an(String)
      expect(merchants[:data][0][:type]).to eq 'merchant'

      expect(merchants[:data][0][:attributes]).to have_key :name
      expect(merchants[:data][0][:attributes][:name]).to be_a String
      expect(merchants[:data][0][:attributes]).to_not have_key :created_at
      expect(merchants[:data][0][:attributes]).to_not have_key :updated_at
      expect(merchants[:data][0][:attributes]).to_not have_key :cohort_id
    end

    describe 'Paginated Merchants' do
      it 'No input returns 20 Merchant' do
        get '/api/v1/merchants?'
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(20)
        expect(merchants[:data][0][:id]).to eq(@all_merch.first.id.to_s)
      end

      it 'fetching page 1 is the same list of first 20 in db' do
        get '/api/v1/merchants?per_page=20&page=1'
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(20)
        expect(merchants[:data][0][:id]).to eq(@all_merch.first.id.to_s)
      end

      # it 'fetching page -1 is the same list of first 20 in db' do
      #   get '/api/v1/merchants?page=-1'
      #   merchants = JSON.parse(response.body, symbolize_names: true)
      #
      #   expect(merchants[:data].count).to eq(20)
      #   expect(merchants[:data][0][:id]).to eq(@all_merch.first.id.to_s)
      # end

      it 'happy path, fetch second page of 20 merchants' do
        get '/api/v1/merchants?per_page=20&page=2'
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(20)
        expect(merchants[:data][0][:id]).to eq(@all_merch[20].id.to_s)
      end

      it 'fetch first page of 50 merchants' do
        get '/api/v1/merchants?per_page=50'
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(50)
      end

      it 'fetch all merchants if per page is really big' do
        get '/api/v1/merchants?per_page=100'
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(@all_merch.count)
      end
    end

    describe 'Get one Merchant' do
      it 'can get merchant by id' do
        id = create(:merchant).id
        get "/api/v1/merchants/#{id}"
        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(merchant[:data][:id]).to eq(id.to_s)
      end

      # context 'when the record does not exist' do
      #   let(:merchant_id) { 100 }
      #
      #   it 'returns status code 404' do
      #     # merchant = JSON.parse(response.body, symbolize_names: true)
      #     get "/api/v1/merchants/#{merchant_id}"
      #
      #     expect(response).to have_http_status(404)
      #   end
      #
      #   it 'returns a not found message' do
      #     merchant = JSON.parse(response.body, symbolize_names: true)
      #
      #     expect(response.body).to match(/Couldn't find Todo/)
      #   end
      # end
    end
  end

  describe 'With no Merchant data' do
    it 'returns empty array' do
      get '/api/v1/merchants?per_page=20&page=2'
      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(0)
      expect(merchants[:data]).to eq([])
    end
  end

end

  # Test suite for GET /merchants/:id
  # describe 'GET /merchants/:id' do
  #   before { get "/merchants/#{merchant_id}" }
  #
  #   context 'when the record exists' do
  #     it 'returns the merchant' do
  #       expect(json).not_to be_empty
  #       expect(json['id']).to eq(merchant_id)
  #     end
  #
  #     it 'returns status code 200' do
  #       expect(response).to have_http_status(200)
  #     end
  #   end
  #
  #   context 'when the record does not exist' do
  #     let(:merchant_id) { 100 }
  #
  #     it 'returns status code 404' do
  #       expect(response).to have_http_status(404)
  #     end
  #
  #     it 'returns a not found message' do
  #       expect(response.body).to match(/Couldn't find Todo/)
  #     end
  #   end
  # end
  #
  # # Test suite for POST /merchants
  # describe 'POST /merchants' do
  #   # valid payload
  #   let(:valid_attributes) { { name: 'Bakery', created_by: '1' } }
  #
  #   context 'when the request is valid' do
  #     before { post '/merchants', params: valid_attributes }
  #
  #     it 'creates a merchant' do
  #       expect(json['name']).to eq('Bakery')
  #     end
  #
  #     it 'returns status code 201' do
  #       expect(response).to have_http_status(201)
  #     end
  #   end
  #
  #   context 'when the request is invalid' do
  #     before { post '/merchants', params: { name: 'Foobar' } }
  #
  #     it 'returns status code 422' do
  #       expect(response).to have_http_status(422)
  #     end
  #
  #     it 'returns a validation failure message' do
  #       expect(response.body)
  #         .to match(/Validation failed: Created by can't be blank/)
  #     end
  #   end
  # end
  #
  # # Test suite for PUT /merchants/:id
  # describe 'PUT /merchants/:id' do
  #   let(:valid_attributes) { { name: 'Liquor Store' } }
  #
  #   context 'when the record exists' do
  #     before { put "/merchants/#{merchant_id}", params: valid_attributes }
  #
  #     it 'updates the record' do
  #       expect(response.body).to be_empty
  #     end
  #
  #     it 'returns status code 204' do
  #       expect(response).to have_http_status(204)
  #     end
  #   end
  # end
  #
  # # Test suite for DELETE /merchants/:id
  # describe 'DELETE /merchants/:id' do
  #   before { delete "/merchants/#{merchant_id}" }
  #
  #   it 'returns status code 204' do
  #     expect(response).to have_http_status(204)
  #   end
  # end
