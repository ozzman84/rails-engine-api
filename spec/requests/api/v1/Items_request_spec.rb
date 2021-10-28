require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe 'With no Item data' do
    it 'returns empty array' do
      get '/api/v1/items?per_page=20&page=2'

      expect(json[:data].size).to eq(0)
      expect(json[:data]).to eq([])
    end
  end

  describe 'With Item data' do
    let!(:all_items) { create_list(:item, 100) }
    let(:item1_id) { all_items[0].id }
    before { get api_v1_items_path }

    describe 'Get all Items' do
      it 'Sends list of Items' do
        get api_v1_items_path

        expect(response).to be_successful

        expect(json).to be_a Hash
        expect(json[:data]).to be_a Array

        expect(json[:data][0].keys).to match_array(%i[attributes id type])
        expect(json[:data][0][:id]).to be_an(String)
        expect(json[:data][0][:type]).to eq 'item'

        expect(json[:data][0][:attributes].keys).to match_array(%i[name description unit_price merchant_id])
        expect(item1[:name]).to be_a String
        expect(item1[:description]).to be_a String
        expect(item1[:unit_price]).to be_a Float
        expect(item1[:merchant_id]).to be_a Integer

        expect(item1).to_not have_key :created_at
        expect(item1).to_not have_key :updated_at
      end

      describe 'Paginated Items' do
        it 'No input returns 20 Item' do
          get '/api/v1/items?'

          expect(json[:data].size).to eq(20)
          expect(json[:data][0][:id]).to eq(item1_id.to_s)
        end

        it 'fetching page 1 is the same list of first 20 in db' do
          get '/api/v1/items?per_page=20&page=1'

          expect(json[:data].size).to eq(20)
          expect(json[:data][0][:id]).to eq(item1_id.to_s)
        end

        it 'fetching page -1 is the same list of first 20 in db' do
          get '/api/v1/items?page=-1'
          items = JSON.parse(response.body, symbolize_names: true)

          expect(items[:data].count).to eq(20)
          expect(items[:data][0][:id]).to eq(all_items.first.id.to_s)
        end

        it 'happy path, fetch second page of 20 items' do
          get '/api/v1/items?per_page=20&page=2'

          expect(json[:data].size).to eq(20)
          expect(item1[:name]).to eq(all_items[20].name)
        end

        it 'fetch first page of 50 items' do
          get '/api/v1/items?per_page=50'

          expect(json[:data].size).to eq(50)
        end

        it 'fetch all items if per page is really big' do
          get '/api/v1/items?per_page=100'

          expect(json[:data].size).to eq(all_items.count)
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
      end

      context 'when the record does not exist' do
        let(:item_id) { Item.last.id + 1 }
        before { get "/api/v1/items/#{item_id}" }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Item/)
        end
      end

      describe 'POST /items' do
        let!(:merchant) { create(:merchant) }
        let(:valid_attributes) { {
          name: "value1",
          description: "value2",
          unit_price: 100.99,
          merchant_id: merchant.id
          }
        }

        context 'when the request is valid' do
          before { post '/api/v1/items', params: { item: valid_attributes } }
          let(:item) { Item.last }

          it 'creates a item' do
            expect(item[:name]).to eq(valid_attributes[:name])
          end

          it 'returns status code 201' do
            expect(response).to have_http_status(201)
          end

          context 'when the request is invalid' do
            before { post '/api/v1/items', params: { name: 'Foobar' } }

            it 'returns status code 422' do
              expect(response).to have_http_status(400)
            end

            it 'returns a validation failure message' do
              expect(response.body).to match(/param is missing or the value is empty: item/)
            end
          end
        end

        describe 'Update Item' do
          let(:valid_attributes) { { name: 'value2' } }

          context 'when the record exists' do
            before { patch "/api/v1/items/#{item1_id}", params: { item: valid_attributes } }

            it 'returns status code 204' do
              expect(response).to have_http_status(200)
            end
          end
        end

        describe 'DELETE Item' do
          before { delete "/api/v1/items/#{item1_id}" }

          it 'returns status code 200' do
            expect(response).to have_http_status(200)
          end
        end
      end
    end
  end
end
