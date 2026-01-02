class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      if user.disabled?
        flash.now[:alert] = "Account disabled."
        return render :new, status: :unprocessable_entity
      end
      
      reset_session
      session[:user_id] = user.id
      redirect_to lists_path
    else
      flash.now[:alert] = "Invalid username or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end
end
