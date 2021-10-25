require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe 'Get all Items' do
    before :each do
      @all_items = create_list(:item, 100)
    end
    before { get api_v1_items_path }

    it 'Sends list of Items' do
      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items).to be_a Hash
      expect(items[:data]).to be_a Array

      expect(items[:data][0].keys).to match_array(%i[attributes id type])
      expect(items[:data][0][:id]).to be_an(String)
      expect(items[:data][0][:type]).to eq 'item'

      expect(items[:data][0][:attributes].keys).to match_array(%i[name description unit_price merchant_id])
      expect(items[:data][0][:attributes][:name]).to be_a String
      expect(items[:data][0][:attributes][:description]).to be_a String
      expect(items[:data][0][:attributes][:unit_price]).to be_a Float
      expect(items[:data][0][:attributes][:merchant_id]).to be_a Integer

      expect(items[:data][0][:attributes]).to_not have_key :created_at
      expect(items[:data][0][:attributes]).to_not have_key :updated_at
    end

    describe 'Paginated Items' do
      it 'No input returns 20 Item' do
        get '/api/v1/items?'
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(20)
        expect(items[:data][0][:id]).to eq(@all_items.first.id.to_s)
      end

      it 'fetching page 1 is the same list of first 20 in db' do
        get '/api/v1/items?per_page=20&page=1'
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(20)
        expect(items[:data][0][:id]).to eq(@all_items.first.id.to_s)
      end

      # it 'fetching page -1 is the same list of first 20 in db' do
      #   get '/api/v1/items?page=-1'
      #   items = JSON.parse(response.body, symbolize_names: true)
      #
      #   expect(items[:data].count).to eq(20)
      #   expect(items[:data][0][:id]).to eq(@all_items.first.id.to_s)
      # end

      it 'happy path, fetch second page of 20 items' do
        get '/api/v1/items?per_page=20&page=2'
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(20)
        expect(items[:data][0][:id]).to eq(@all_items[20].id.to_s)
      end

      it 'fetch first page of 50 items' do
        get '/api/v1/items?per_page=50'
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(50)
      end

      it 'fetch all items if per page is really big' do
        get '/api/v1/items?per_page=100'
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(@all_items.count)
      end
    end

    describe 'Get one Item' do
      it 'can get item by id' do
        id = create(:item).id
        get "/api/v1/items/#{id}"
        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(item[:data][:id]).to eq(id.to_s)
      end

      # context 'when the record does not exist' do
      #   let(:item_id) { 100 }
      #
      #   it 'returns status code 404' do
      #     # item = JSON.parse(response.body, symbolize_names: true)
      #     get "/api/v1/items/#{item_id}"
      #
      #     expect(response).to have_http_status(404)
      #   end
      #
      #   it 'returns a not found message' do
      #     item = JSON.parse(response.body, symbolize_names: true)
      #
      #     expect(response.body).to match(/Couldn't find Todo/)
      #   end
      # end
    end
  end

  describe 'With no Item data' do
    it 'returns empty array' do
      get '/api/v1/items?per_page=20&page=2'
      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(0)
      expect(items[:data]).to eq([])
    end
  end
end

  # Test suite for GET /items/:id
  # describe 'GET /items/:id' do
  #   before { get "/items/#{item_id}" }
  #
  #   context 'when the record exists' do
  #     it 'returns the item' do
  #       expect(json).not_to be_empty
  #       expect(json['id']).to eq(item_id)
  #     end
  #
  #     it 'returns status code 200' do
  #       expect(response).to have_http_status(200)
  #     end
  #   end
  #
  #   context 'when the record does not exist' do
  #     let(:item_id) { 100 }
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
  # # Test suite for POST /items
  # describe 'POST /items' do
  #   # valid payload
  #   let(:valid_attributes) { { name: 'Bakery', created_by: '1' } }
  #
  #   context 'when the request is valid' do
  #     before { post '/items', params: valid_attributes }
  #
  #     it 'creates a item' do
  #       expect(json['name']).to eq('Bakery')
  #     end
  #
  #     it 'returns status code 201' do
  #       expect(response).to have_http_status(201)
  #     end
  #   end
  #
  #   context 'when the request is invalid' do
  #     before { post '/items', params: { name: 'Foobar' } }
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
  # # Test suite for PUT /items/:id
  # describe 'PUT /items/:id' do
  #   let(:valid_attributes) { { name: 'Liquor Store' } }
  #
  #   context 'when the record exists' do
  #     before { put "/items/#{item_id}", params: valid_attributes }
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
  # # Test suite for DELETE /items/:id
  # describe 'DELETE /items/:id' do
  #   before { delete "/items/#{item_id}" }
  #
  #   it 'returns status code 204' do
  #     expect(response).to have_http_status(204)
  #   end
  # end
