class ListsController < ApplicationController
  before_action :require_login!
  before_action :set_list, only: [ :show, :destroy, :sharing ]
  before_action :require_list_view!, only: [ :show ]
  before_action :require_list_edit!, only: [ :destroy, :sharing ]
  
  def index
    @lists = List
               .left_joins(:list_memberships)
               .where("lists.owner_id = :uid OR list_memberships.user_id = :uid", uid: current_user.id)
               .distinct
               .order(updated_at: :desc)
  end

  def show
    @items = @list.items.order(:id)
    @item = @list.items.new
  end

  def new
    @list = current_user.owned_lists.new
  end

  def create
    @list = current_user.owned_lists.new(list_params)

    if @list.save
      @list.list_memberships.find_or_create_by!(user: current_user) { |m| m.role = :editor }
      
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to list_path(@list) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream:
                 turbo_stream.replace(
                   "new_list_form",
                   partial: "lists/form",
                   locals: { list: @list }
                 ),
                 status: :unprocessable_entity
        end
        format.html do
          flash.now[:alert] = @list.errors.full_messages.first
          render :new, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @list.destroy!
    redirect_to lists_path
  end

  def sharing
    @memberships = @list.list_memberships.includes(:user).order(:id)
  end
  
  private

  def list_params
    params.require(:list).permit(:title)
  end

  def set_list
    @list = List.find(params[:id])
  end

  def require_list_view!
    return if @list.viewable_by?(current_user)
    redirect_to lists_path, alert: "Unauthorized"
  end

  def require_list_edit!
    return if @list.editable_by?(current_user)
    redirect_to list_path(@list), alert: "Read-only access"
  end
end
