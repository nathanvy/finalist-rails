class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    raw_token = params[:signup_token].to_s.strip
    if raw_token.blank?
      flash.now[:alert] = "Invite key is required"
      @user = User.new(user_params)
      return render :new, status: :unprocessable_entity
    end

    digest = TokenDigest.digest(raw_token)
    @user = User.new(user_params)

    created = false

    SignupToken.transaction do
      token = SignupToken.lock.find_by(token_digest: digest)
      unless token&.usable?
        flash.now[:alert] = "Invalid or expired invite key"
        raise ActiveRecord::Rollback
      end

      unless @user.save
        flash.now[:alert] = @user.errors.full_messages.first
        raise ActiveRecord::Rollback
      end

      token.increment!(:uses_count)

      reset_session
      session[:user_id] = @user.id
      created = true
    end

    if created
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
