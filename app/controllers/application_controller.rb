class ApplicationController < ActionController::Base
  before_action :authenticate_request

  def authenticate_request
    @current_user = Users::CheckAuth.call(cookies).result
    
    redirect_to login_path unless @current_user
  end
end
