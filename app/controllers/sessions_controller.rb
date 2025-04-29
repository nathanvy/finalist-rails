#inherit from actioncontroller not apicontroller so that we don't run the auth filter
class SessionsController < ActionController::API
  # skip auth for public routes
  skip_before_action :authenticate!, raise: false

  def create
    user = User.find_by(username: params[:username])
  
    if user && BCrypt::PAssword.new(user.pwhash) == params[:password]
      sid = SecureRandom.base64(32)
      Session.create!(sid: sid, account: user.index)
      user.update!(lastlogin: Time.current) if user.respond_to?(:lastlogin)

      cookies[:auth] = {
        value: sid,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :strict,
        path: '/'
      }

      render json: { success: ':Logged in successfully' }, status :ok
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end

  rescue => e
    Rails.logger.error("Login error: #{e.message}")
    render json: { error: 'Internal Server Error' },
           status: :internal_server_error
  end

  def destroy
    token = cookies[:auth] || request.headers['Authorization']&.split&.last
    Session.find_by(sid: token)&.destroy
    head :no_content
  end
end
