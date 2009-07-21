require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Kennels::RatingsController do
  describe 'POST create' do
    before do
      @kennel = Factory(:kennel, :number_of_ratings => 1, :rating => 5)
      Kennel.stub(:find).and_return(@kennel)
    end
    it 'should load up the owner details specified in the url' do
      Kennel.should_receive(:find).and_return(@kennel)
      post :create, {:rating => { :rating => '3'}}
    end
    it 'should increase the total number of ratings' do
      @kennel.should_receive(:number_of_ratings=).with(2)
      post :create, {:rating => { :rating => '3'}}
    end
    it 'should recalculate the average rating correctly' do
      @kennel.should_receive(:rating=).with(4)
      post :create, {:rating => { :rating => '3'}}
    end
    it 'should save the kennel' do
      @kennel.should_receive(:save)
      post :create, {:rating => { :rating => '3'}}
    end
  end
end