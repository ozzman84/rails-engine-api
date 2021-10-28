class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    validate_params
    merch_by_rev = Merchant.desc_total_rev(params[:quantity])
    render json: MerchantNameRevenueSerializer.new(merch_by_rev)
  end

  def show
    merch_rev = Merchant.total_rev(params[:id])
    render json: MerchantRevenueSerializer.new(merch_rev)
  end

  private

  def validate_params
    raise ActionController::BadRequest unless valid_params?
  end

  def valid_params?
    params[:quantity]&.to_i&.positive?
  end
end
