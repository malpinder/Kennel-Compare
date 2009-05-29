module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the main page/
      root_path

    when /the "choose new account type" page/
      choose_account_type_path

    when /the new owner page/
      new_owner_path

    when /the new kennel page/
      new_kennel_path
    
    # Add more page name => path mappings here
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
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

    when /the new kennel page/
      new_kennel_url

    # Add more page name => path mappings here

    else
      raise "Can't find mapping from \"#{url_name}\" to a url."
    end
  end
end

World do |world|
  world.extend NavigationHelpers
  world
end
