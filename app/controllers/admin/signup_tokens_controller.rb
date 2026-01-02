class Admin::SignupTokensController < Admin::BaseController
  def index
    @tokens = SignupToken.order(created_at: :desc)
  end

  def new
    @token = SignupToken.new
  end

  def create
    raw_token = SecureRandom.urlsafe_base64(32)
    digest = TokenDigest.digest(raw_token)

    @token = SignupToken.new(token_params.merge(
      token_digest: digest,
      created_by_user: current_user
    ))

    if @token.save
      # Show the raw token once.
      flash.now[:alert] = "Invite key: #{raw_token}"
      @tokens = SignupToken.order(created_at: :desc)
      render :index
    else
      flash.now[:alert] = @token.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end

  def revoke
    token = SignupToken.find(params[:id])
    token.update!(revoked_at: Time.current)
    redirect_to admin_signup_tokens_path
  end

  private

  def token_params
    params.require(:signup_token).permit(:label, :expires_at, :max_uses)
  end
end
