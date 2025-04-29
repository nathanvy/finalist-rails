class ListsController < ActionController::API
  def index
    render json: List.all
  end
  
  def show
    list = List.find(params[:id])
    render json: list, include: [:contentlists, :permissions]
  end

  # rest of crud goes here
end
