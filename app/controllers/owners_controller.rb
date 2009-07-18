class OwnersController < ApplicationController
  before_filter :ensure_logged_in_user, :only => [:edit, :update]
  before_filter :only => [:edit, :update] do |controller|
    controller.ensure_authorised_owner(controller.params[:id])
  end

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
    @owner = Owner.find(params[:id])
  end
  def update
    @owner = Owner.find(params[:id])

    unless @owner.update_attributes(params[:owner])
      flash[:error] = 'Update failed.'
      redirect_to edit_owner_path(@owner) and return
    end

    flash[:notice] = 'Updated details succesfully.'
    redirect_to owner_path(@owner)
  end
end
