class KennelsController < ApplicationController
  before_filter :ensure_logged_in_user, :only => [:edit, :update]
  before_filter :only => [:edit, :update] do |controller|
    controller.ensure_authorised_kennel(controller.params[:id])
  end
  
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
    @kennel = Kennel.find(params[:id])
  end
  def update
    @kennel = Kennel.find(params[:id])

    unless @kennel.update_attributes(params[:kennel])
      flash[:error] = 'Update failed.'
      redirect_to edit_kennel_path(@kennel) and return
    end

    flash[:notice] = 'Updated details succesfully.'
    redirect_to kennel_path(@kennel)
  end
end
