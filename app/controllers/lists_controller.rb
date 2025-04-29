class ListsController < ApiController
  def index
    lists = List
              .joins(:permissions)
              .where(permissions: { user_id: @current_user.index })
    render json: lists, include: :contentlists
  end

  def show
    list = List.find(params[:id])
    authorize!(list)
    render json: list, include: %i[contentlists permissions]
  end

  #more crud here TODO

  private

  def list_params
    params.require(:list).permit(:listname)
  end

  def authorize!(list)
    head :forbidden unless
      Permission.exists?(list_id: list.id, user_id: @current_user.index)
  end
end
