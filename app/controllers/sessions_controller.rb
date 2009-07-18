class SessionsController < ApplicationController
  def new

  end
  def create
    account_type = params[:account][:type]
    return unless %w{ owner kennel }.include?(account_type)

    @user = account_type.capitalize.constantize.send("existing_#{account_type}_account", params[:account])

    if @user.nil?
      flash[:warning] = 'Incorrect details provided.'
      redirect_to new_session_path
      return
    end

    session[:user_id] = @user.id
    session[:user_type] = account_type.pluralize
    flash[:notice] = 'You have been logged in.'
    redirect_to self.send("#{account_type}_path", @user.id)
  end

  def destroy
    session[:user_id] = nil
    session[:user_type] = nil
    flash[:notice] = 'You have been logged out sucessfully.'
    redirect_to new_session_path
  end
end
