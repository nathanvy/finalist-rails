class ListsController < ApiController
  def index
    lists = List
              .joins(:permissions)
              .where(permissions: { user_id: @current_user.index })
    render json: lists.as_json(only: %i[id listname])
  end

  def show
    list = List.find(params[:id])
    return unless authorize!(list)
    
    items = list.contentlists
              .order(:index)
              .as_json(only: %i[index content])

    render json: items
  end

  #more crud here TODO

  private

  def list_params
    params.require(:list).permit(:listname)
  end

  def authorize!(list)
    unless Permission.exists?(list_id: list.id, user_id: @current_user.index)
      head :forbidden
      return false
    end
    true
  end
end
