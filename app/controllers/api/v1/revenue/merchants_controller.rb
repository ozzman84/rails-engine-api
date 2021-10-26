class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    @merch_by_rev = Merchant.desc_rev(params[:quantity])
    render json: MerchantSerializer.new(merch_by_rev)
  end
end
