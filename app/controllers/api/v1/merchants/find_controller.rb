class Api::V1::Merchants::FindController < ApplicationController
  def index
    merchant = Merchant.find_with_name(params[:name]).last
    if merchant
      render json: MerchantSerializer.new(merchant)
    else
      render json: { data: {
        message: 'No Merchants match your search',
        status: 400
      } }
    end
  end
end
