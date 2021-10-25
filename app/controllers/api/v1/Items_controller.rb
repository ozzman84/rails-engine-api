class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all.offset(page * per_page).limit(per_page)
    render json: ItemSerializer.new(items)
  end

  def show
    merchant = Item.find(params[:id])
    render json: ItemSerializer.new(merchant)
  end

  private
  #is a singular param stated without the s? param vs params
  def page
    if params[:page].to_i <= 1
      @page = 0
    else
      @page = params[:page].to_i - 1
    end
  end

  def per_page
    @per_page = (params[:per_page] || 20).to_i
  end
end
