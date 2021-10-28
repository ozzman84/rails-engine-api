class Api::V1::Revenue::UnshippedController < ApplicationController
  def index
    unshipped_orders = Invoice.unshipped_rev(params[:quantity])
    render json: UnshippedOrderSerializer.new(unshipped_orders)
  end
end
