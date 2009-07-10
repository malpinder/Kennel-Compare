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

end
