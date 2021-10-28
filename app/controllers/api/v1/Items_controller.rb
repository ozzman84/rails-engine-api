class Api::V1::ItemsController < ApplicationController
  # before_action :set_merchant, except: :show
  before_action :set_item, only: %i[update destroy]

  def index
    items = Item.all.offset(page * per_page).limit(per_page)
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item)
  end

  def create
    @new_item = Item.create!(item_params)
    @serialized_items = ItemSerializer.new(@new_item)
    json_response(@serialized_items, :created)
  end

  def update
    @item.update!(item_params)
    render json: ItemSerializer.new(@item)
    # render json_response(@serialized_items)
  end

  def destroy
    render json: @item.destroy
    # head :no_content
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

  # def set_merchant
  #   @merchant = Merchant.find(params[:merchant_id])
  # end

  def set_item
    @item = Item.find(params[:id])
  end

  def page
    if params[:page].to_i <= 0
      @page = 0
    else
      @page = params[:page].to_i - 1
    end
  end

  def per_page
    @per_page = (params[:per_page] || 20).to_i
  end
end
