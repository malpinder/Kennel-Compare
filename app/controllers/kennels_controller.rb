class KennelsController < ApplicationController
  def new
    @kennel = Kennel.new
  end

  def create
    @kennel = Kennel.new(params[:kennel])

    unless @kennel.valid?
      render :action => :new and return
    end

    @kennel.save
    session[:user_type] = 'kennels'
    session[:user_id] = @kennel.id
    redirect_to kennel_path(@kennel)
  end
  def edit
    unless page_viewed_by_authorised_user?
      if logged_in?
        flash[:warning] = 'You do not have permissions to edit that user\'s settings. You have been redirected to your own account page.'
        redirect_to kennel_path(session[:user_id]) and return
      else
        flash[:warning] = 'You must be logged in to view that page.'
        redirect_to new_session_path and return
      end
    end

    @kennel = Kennel.find(params[:id])
  end
  def update
    unless page_viewed_by_authorised_user?
      flash[:warning] = 'You do not have permission to update those details.'
      if logged_in?
        #pulls the user type and id out of the session and inserts it into the route
        redirect_to(self.send("edit_#{session[:user_type].singularize}_path".to_sym, {:id => session[:user_id]})) and return
      else
        redirect_to new_session_path and return
      end
    end
    @kennel = Kennel.find(params[:id])

    unless @kennel.update_attributes(params[:kennel])
      flash[:error] = 'Update failed.'
      redirect_to edit_kennel_path(@kennel) and return
    end

    flash[:notice] = 'Updated details succesfully.'
    redirect_to kennel_path(@kennel)
  end
end
