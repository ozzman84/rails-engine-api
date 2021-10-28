class Api::V1::Merchants::MostItemsController < ApplicationController
  def index
    validate_params
    merch_by_items_sold = Merchant.desc_most_items_sold(params[:quantity])
    render json: ItemsSoldSerializer.new(merch_by_items_sold)
  end

  private

  def validate_params
    raise ActionController::BadRequest unless valid_params?
  end

  def valid_params?
    params[:quantity]&.to_i&.positive?
  end
end
