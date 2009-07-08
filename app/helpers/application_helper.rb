# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def logged_in?
    not session[:user_id].nil?
  end
  def current_user_name
    if session[:user_type] == 'owner'
      user = Owner.find_by_id(session[:user_id])
      return "#{user.first_name} #{user.surname}"
    end
    if session[:user_type] == 'kennel'
      user = Kennel.find_by_id(session[:user_id])
      return "#{user.kennel_name}"
    end
  end
  def page_viewed_by_authorised_user?
    unless logged_in?
      @warning_message = 'You must be logged in as an authorised user to access this page.'
      return false
    end

    return true if session[:user_id] == request.path_parameters[:id] && session[:user_type] == request.path_parameters[:controller]
    @warning_message = 'You do not have the correct permissions to access this page.'
    false
  end
end
