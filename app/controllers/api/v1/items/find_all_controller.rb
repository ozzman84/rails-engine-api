class Api::V1::Items::FindAllController < ApplicationController
  def index
    items = Item.search_all(params[:name])
    render json: ItemSerializer.new(items)
  end
end
