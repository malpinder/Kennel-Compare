module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the main page/
      root_path

    when /the "choose new account type" page/
      choose_account_type_path

    when /the new owner page/
      new_owner_path
    when /the owner account page/
      owner_path(:id => '1')

    when /the new kennel page/
      new_kennel_path
    when /the kennel account page/
      kennel_path(:id => '1')

    when /the login page/
      new_session_path

    when /the first pet owner account page/
      owner_path(:id => '1')
    when /my account page/
      owner_path(:id => '1')

    when /the first pet owner edit page/
      edit_owner_path(:id => '1')
    when /my edit page/
      edit_owner_path(:id => '1')

    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n"
    end
  end
  def url_to(url_name)
    case url_name

      when /the main page/
        root_url

      when /the "choose new account type" page/
        choose_account_type_url

      when /the new owner page/
        new_owner_url
     when /the owner account page/
        owner_url(:id => '1')

      when /the new kennel page/
        new_kennel_url
      when /the kennel account page/
        kennel_url(:id => '1')

      when /the login page/
        new_session_url

      when /the first pet owner account page/
        owner_url(:id => '1')
      when /my account page/
        owner_url(:id => '1')

      when /the first pet owner edit page/
        edit_owner_url(:id => '1')
      when /my edit page/
        edit_owner_url(:id => '1')

    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{url_name}\" to a url.\n"
    end
  end
end

World(NavigationHelpers)
