require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
 describe 'page_viewed_by_authorised_user?' do
    before do
      request.stub(:path_parameters).and_return({:controller => 'owners', :id => '1'})
    end
    it 'should return false if there is no user logged in' do
      controller.page_viewed_by_authorised_user?.should be_false
    end
    it 'should return false if the user types match, but not the ids' do
      session[:user_id] = '2'
      session[:user_type] = 'owners'
      controller.page_viewed_by_authorised_user?.should be_false
    end
    it 'should return false if the ids match but not the user types' do
      session[:user_id] = '1'
      session[:user_type] = 'kennels'
      controller.page_viewed_by_authorised_user?.should be_false
    end
    it 'should return true if the ids and user types match' do
      session[:user_id] = '1'
      session[:user_type] = 'owners'
      controller.page_viewed_by_authorised_user?.should be_true
    end
  end
end