class SessionsController < ApplicationController
  def new

  end
  def create
    if params[:account][:type].to_s == 'owner'
      @owner = Owner.existing_owner_account(params[:account])

      if @owner.nil?
        flash[:warning] = 'Incorrect details provided.'
        redirect_to new_session_path
        return
      end

      session[:user_id] = @owner.id
      session[:user_type] = 'owners'
      flash[:notice] = 'You have been logged in.'
      redirect_to owner_path(@owner.id)

      else if params[:account][:type].to_s == 'kennel'
        @kennel = Kennel.valid_kennel_account(params[:account])

        if @kennel.nil?
          flash[:warning] = 'Incorrect details provided.'
          redirect_to new_session_path
          return
        end

        session[:user_id] = @kennel.id
        session[:user_type] = 'kennels'
        flash[:notice] = 'You have been logged in.'
        redirect_to kennel_path(@kennel.id)
      else
        raise "how'd you manage that?"
      end
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_type] = nil
    flash[:notice] = 'You have been logged out sucessfully.'
    redirect_to new_session_path
  end
end
