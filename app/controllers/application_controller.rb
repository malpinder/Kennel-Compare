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
  
  def page_viewed_by_authorised_user?(user_type = request.params[:controller], user_id = request.params[:id])
    return true if session[:user_id].to_i == user_id.to_i && session[:user_type] == user_type
    false
  end

  def ensure_logged_in_user
    unless logged_in?
      flash[:warning] = 'Please log in.'
      redirect_to new_session_path
      return false
    end
    true
  end
  def ensure_authorised_owner(user_id)
    ensure_authorised_user('owners', user_id)
  end
  def ensure_authorised_kennel(user_id)
    ensure_authorised_user('kennels', user_id)
  end

  def ensure_authorised_user(user_type = request.params[:controller], user_id = request.params[:id])
    unless page_viewed_by_authorised_user?(user_type, user_id)
      flash[:warning] = 'You do not have permission to update those details.'
      if logged_in?
        redirect_to(self.send("edit_#{session[:user_type].singularize}_path".to_sym, {:id => session[:user_id]}))
        return false
      else
        redirect_to new_session_path
        return false
      end
    end
    true
  end

end
