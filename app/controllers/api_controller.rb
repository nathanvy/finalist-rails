class ApiController < ActionController::API
  before_action :authenticate!
  
  private
  
  def authenticate!
    token = cookies[:auth] || request.headers['Authorization']&.split&.last
    session = Session.find_by(sid: token)
    return head :unauthorized unless session
    
    @current_user = User.find(session.account)
  end
end
