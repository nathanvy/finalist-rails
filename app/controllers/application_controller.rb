class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def current_user
    return @current_user if defined?(@current_user)

    user_id = session[:user_id]
    @current_user = user_id && User.find_by(id: user_id)
  end

  def logged_in?
    current_user.present?
  end

  def require_login!
    unless logged_in?
      redirect_to new_session_path, alert: "Please log in."
      return
    end

    if current_user.disabled?
      reset_session
      redirect_to new_session_path, alert: "Account disabled."
    end
  end

  def require_admin!
    require_login!
    head :forbidden unless current_user&.admin?
  end
end
