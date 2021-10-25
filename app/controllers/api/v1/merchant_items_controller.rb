class Api::V1::MerchantItemsController < ApplicationController
  def index
    merch_items = Merchant.find(params[:id]).items
    render json: ItemSerializer.new(merch_items)
  end
end
