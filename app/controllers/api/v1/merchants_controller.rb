class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all.offset(page * per_page).limit(per_page)
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant)
  end

  private

  def page
    if params[:page].to_i <= 1
      @page = 0
    else
      @page = params[:page].to_i - 1
    end
  end

  def per_page
    if params[:per_page].nil? || params[:per_page]&.to_i <= 0
      20
    else
      params[:per_page].to_i
    end
  end
end
