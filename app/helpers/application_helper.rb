# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def current_user_name
    if session[:user_type] == 'owners'
      user = Owner.find_by_id(session[:user_id])
      return "#{user.first_name} #{user.surname}"
    end
    if session[:user_type] == 'kennels'
      user = Kennel.find_by_id(session[:user_id])
      return "#{user.kennel_name}"
    end
  end

  def page_viewed_by_pet_owner?
    return true if session[:user_type].to_s == 'owners'
    false
  end

end
