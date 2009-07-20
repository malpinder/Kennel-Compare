class AddRatingToKennels < ActiveRecord::Migration
  def self.up
    add_column :kennels, :rating, :integer, :default => 0
    add_column :kennels, :number_of_ratings, :integer, :default => 0
  end

  def self.down
    remove_column :kennels, :rating
    remove_column :kennels, :number_of_ratings
  end
end
