class Kennels::RatingsController < ApplicationController

  def new

  end
  def create
    @kennel = Kennel.find(params[:kennel_id])
    
    @kennel.number_of_ratings += 1
    @kennel.rating = calculate_new_rating(@kennel, params[:rating][:rating])

    @kennel.save
    redirect_to kennel_path(@kennel)
  end

  def calculate_new_rating(kennel, rating)
    old_rating = kennel.rating
    new_rating = (old_rating + rating.to_i)/(kennel.number_of_ratings)
  end
end
