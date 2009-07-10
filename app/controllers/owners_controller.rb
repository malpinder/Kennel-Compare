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
    session[:user_type] = 'owner'
    session[:user_id] = @owner.id
    redirect_to owner_path(@owner)
  end

  def show
    if page_viewed_by_authorised_user == false
      redirect_to root_path
      return
    end
    raise 'aarabdefkbsdflfbjldfg'
  end
  def edit
  end
end
