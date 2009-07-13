# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  helper_method :logged_in?, :page_viewed_by_authorised_user?
  def logged_in?
    !!session[:user_id]
  end
  
  def page_viewed_by_authorised_user?
    return true if session[:user_id].to_i == request.params[:id].to_i && session[:user_type] == request.params[:controller]
    false
  end

end
