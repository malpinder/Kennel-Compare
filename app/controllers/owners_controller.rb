class OwnersController < ApplicationController
  def new
    @owner = Owner.new
  end

  def create
    @owner = Owner.new(params[:owner])

    unless @owner.valid?
      render :action => :new
      return
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
        redirect_to owner_path(session[:user_id])
        return
      end
      flash[:warning] = 'You must be logged in to view that page.'
      redirect_to new_session_path
    end
    
  end
end
