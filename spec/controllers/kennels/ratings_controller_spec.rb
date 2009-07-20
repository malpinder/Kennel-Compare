require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Kennels::RatingsController do
  describe 'POST create' do
    before do
      @kennel = mock_model(Kennel, {:rating => 5, :number_of_ratings => 1})
      @kennel.stub(:rating= => true, :number_of_ratings= => true, :save => true)
      Kennel.stub(:find).and_return(@kennel)
    end
    it 'should load up the owner details specified in the url' do
      Kennel.should_receive(:find).and_return(@kennel)
      post :create, {:rating => { :rating => '3'}}
    end
    it 'should increase the total number of ratings' do
      @kennel.should_receive(:number_of_ratings=)
      post :create, {:rating => { :rating => '3'}}
    end
    it 'should recalculate the average rating' do
      @kennel.should_receive(:rating=)
      post :create, {:rating => { :rating => '3'}}
    end
    it 'should save the kennel' do
      @kennel.should_receive(:save)
      post :create, {:rating => { :rating => '3'}}
    end
  end

  describe 'calculate_new_rating' do
    before do
      @kennel = mock_model(Kennel, {:rating => 5, :number_of_ratings => 2})
    end
    it 'should accept two arguments' do
      lambda{ controller.calculate_new_rating(@kennel, 3) }.should_not raise_error
    end
    it 'should calculate the new average rating' do 
      controller.calculate_new_rating(@kennel, 3).should == 4
    end
  end
end