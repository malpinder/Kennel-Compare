class OwnersController < ApplicationController
  def new
    @owner = Owner.new
  end

  def create
    @owner = Owner.new(params[:owner])

    unless @owner.valid?
      render :action => :new and return
    end

    @owner.save
    session[:user_type] = 'owners'
    session[:user_id] = @owner.id
    redirect_to owner_path(@owner)
  end

  def show
  end
  def edit
    unless page_viewed_by_authorised_user?
      if logged_in?
        flash[:warning] = 'You do not have permissions to edit that user\'s settings. You have been redirected to your own account page.'
        redirect_to owner_path(session[:user_id]) and return
      else
        flash[:warning] = 'You must be logged in to view that page.'
        redirect_to new_session_path and return
      end
    end

    @owner = Owner.find(params[:id])
  end
  def update
    unless page_viewed_by_authorised_user?
      flash[:warning] = 'You do not have permission to update those details.'
      if logged_in?
        #pulls the user type and id out of the session and inserts it into the route
        redirect_to(self.send("edit_#{session[:user_type]}_path".to_sym, {:id => session[:user_id]})) and return
      else
        redirect_to new_session_path and return
      end
    end
    @owner = Owner.find(params[:id])

    unless @owner.update_attributes(params[:owner])
      flash[:error] = 'Update failed.'
      redirect_to edit_owner_path(@owner) and return
    end

    flash[:notice] = 'Updated details succesfully.'
    redirect_to owner_path(@owner)
  end
end
