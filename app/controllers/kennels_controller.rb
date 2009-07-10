class KennelsController < ApplicationController
  def new
    @kennel = Kennel.new
  end

  def create
    @kennel = Kennel.new(params[:kennel])

    unless @kennel.valid?
      render :action => :new
      return
    end

    @kennel.save
    session[:user_type] = 'kennels'
    session[:user_id] = @kennel.id
    redirect_to kennel_path(@kennel)
  end
end
