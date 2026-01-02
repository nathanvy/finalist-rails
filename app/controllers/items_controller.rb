class ItemsController < ApplicationController
  before_action :require_login!
  before_action :set_list
  before_action :require_list_edit!
  before_action :set_item, only: [ :show, :edit, :update, :destroy ]

  def show
  end

  def edit
  end
  
  def create
    @item = @list.items.new(item_params)
    
    if @item.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to list_path(@list) }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
                   "new_item_form",
                   partial: "items/form",
                   locals: { list: @list, item: @item }
                 ),
                 status: :unprocessable_entity
        end
        format.html { redirect_to list_path(@list), alert: @item.errors.full_messages.first }
      end
    end
  end
  
  def update
    if @item.update(item_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to list_path(@list) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@item, partial: "items/item", locals: { item: @item, list: @list }) }
        format.html do
          flash[:alert] = @item.errors.full_messages.first
          redirect_to list_path(@list)
        end
      end
    end
  end

  # note to self: capture IDs before deletion so we know what to remove client-side
  def clear_completed
    @completed_ids = @list.items.completed.pluck(:id)
    @list.items.completed.delete_all
    
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to list_path(@list) }
    end
  end

  def destroy
    @item.destroy!
    
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to list_path(@list) }
    end
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def set_item
    @item = @list.items.find(params[:id])
  end

  def require_list_edit!
    return if @list.editable_by?(current_user)
    redirect_to list_path(@list), alert: "Read-only access"
  end

  def item_params
    params.require(:item).permit(:body, :completed)
  end
end
