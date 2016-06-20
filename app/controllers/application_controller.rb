class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :api_current_user

  delegate(
    :current_user,
    :github_id,
    :require_admin,
    :require_authentication,
    :api_current_user,
    :via,
    to: :authenticator
  )

  rescue_from 'UnauthorizedError::MustBeAdmin' do |error|
    message = error.message || "Unauthorized"
    handle_error(message)
  end

  rescue_from 'UnauthorizedError::RedirectToLogin' do |error|
    store_location
    redirect_to login_path
  end

  rescue_from 'UnauthorizedError::UserNotFound' do |error|
    message = error.message || "User not found"
    handle_error(message)
  end

  protected

  def authenticator
    @_authenticator ||= WebAuthenticator.new(self)
  end

  def handle_error(message)
    flash[:error] = message
    redirect_to root_path
  end

  def store_location
    if request.get?
      session[:return_to] = request.original_fullpath
    end
  end

  def store_referer
    if request.get?
      session[:return_to] = request.referer
    end
  end

  def return_to_stored(default: root_path)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
