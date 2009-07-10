# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  def logged_in?
    not session[:user_id].nil?
  end
  
  def page_viewed_by_authorised_user
    unless logged_in?
      flash[:warning] = 'You must be logged in as an authorised user to access this page.'
      redirect_to session_path and return
    end

    return true if session[:user_id] == request.params[:id] && session[:user_type] == request.params[:controller]
    flash[:warning] = 'You do not have the correct permissions to access this page.'
    false
  end

end
