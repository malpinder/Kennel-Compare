class Kennels::RatingsController < ApplicationController

  def new

  end
  def create
    @kennel = Kennel.find(params[:kennel_id])
    
    @kennel.number_of_ratings += 1
    new_rating = (@kennel.rating + params[:rating][:rating].to_i)/(@kennel.number_of_ratings)
    @kennel.rating = new_rating

    @kennel.save
    redirect_to kennel_path(@kennel)
  end
end
