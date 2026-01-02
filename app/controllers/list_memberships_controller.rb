class ListMembershipsController < ApplicationController
  before_action :require_login!
  before_action :set_list
  before_action :require_list_edit!

  def create
    username = params[:username].to_s.strip
    user = User.find_by(username: username)

    return redirect_to sharing_list_path(@list), alert: "User not found." if user.nil?
    return redirect_to sharing_list_path(@list), alert: "Owner already has access." if user.id == @list.owner_id

    membership = @list.list_memberships.find_or_initialize_by(user: user)
    membership.role ||= :editor # default share role
    membership.save!

    redirect_to sharing_list_path(@list)
  end

  def update
    membership = @list.list_memberships.find(params[:id])
    return redirect_to sharing_list_path(@list), alert: "Cannot change owner role." if membership.user_id == @list.owner_id

    role = params.require(:list_membership).permit(:role)[:role]
    membership.update!(role: role)

    redirect_to sharing_list_path(@list)
  end

  def destroy
    membership = @list.list_memberships.find(params[:id])
    return redirect_to sharing_list_path(@list), alert: "Cannot remove owner." if membership.user_id == @list.owner_id

    membership.destroy!
    redirect_to sharing_list_path(@list)
  end

  private

  def set_list
    @list = List.find(params[:list_id])
  end

  def require_list_edit!
    return if @list.editable_by?(current_user)
    redirect_to list_path(@list), alert: "Read-only access"
  end
end
