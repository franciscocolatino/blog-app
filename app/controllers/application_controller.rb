class ApplicationController < ActionController::Base
  before_action :authenticate_request

  def authenticate_request
    @current_user = Users::CheckAuth.call(cookies).result

    return unless authentication_required?

    redirect_to login_path unless @current_user
  end

  def authentication_required?
    public_routes = {
      "posts" => %w[index show],
      "comments" => %w[index create]
    }

    !public_routes.fetch(controller_name, []).include?(action_name)
  end
end
