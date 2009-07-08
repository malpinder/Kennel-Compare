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
  end
  def edit
  end
end
