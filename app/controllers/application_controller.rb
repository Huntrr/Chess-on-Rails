class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method def logged_in?
    session[:user_id]
  end

  helper_method def current_user
    @logged_in_user ||= User.find(session[:user_id]) if logged_in?
  end

  helper_method def is?(user)
    logged_in? && session[:user_id] == user.id
  end
end
