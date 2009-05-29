class WelcomeController < ApplicationController

  def new
    if request.post?
      redirect_to new_owner_path if params[:account][:type].to_s == 'owner'
      redirect_to new_kennel_path if params[:account][:type].to_s == 'kennel'
    end
  end
end
