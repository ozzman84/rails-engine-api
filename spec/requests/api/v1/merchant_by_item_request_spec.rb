require 'rails_helper'

RSpec.describe 'Merchant By Item ID', type: :request do
  describe 'returns Merchant Using an Item ID' do
    let!(:all_items) { create_list(:item, 1)}
  end
end
