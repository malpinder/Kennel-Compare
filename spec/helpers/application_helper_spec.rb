require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe ApplicationHelper do

  describe 'current_user_name' do
    it 'should return the name of any owner who is logged in' do
      @user = mock_model(Owner, {:first_name => 'Anita', :surname => 'Dearly'})
      Owner.stub!(:find).and_return(@user)
      session[:user_id] = '1'
      session[:user_type] = 'owners'
      helper.current_user_name.should == 'Anita Dearly'
    end
    it 'should return the name of any kennel who is logged in' do
      @user = mock_model(Kennel, {:kennel_name => 'Doghouse'})
      Kennel.stub!(:find).and_return(@user)
      session[:user_id] = '1'
      session[:user_type] = 'kennels'
      helper.current_user_name.should == 'Doghouse'
    end
    it 'should return nil if there is no one logged in' do
      helper.current_user_name.should be_nil
    end
  end

  describe 'page_viewed_by_pet_owner?' do
    it 'should return false is there is no-one logged in' do
      helper.page_viewed_by_pet_owner?.should be_false
    end
    it 'should return false if there is a different type of user logged in' do
      session[:user_type]= 'kennels'
      helper.page_viewed_by_pet_owner?.should be_false
    end
    it 'should return true if there is a pet owner logged in' do
      session[:user_type]= 'owners'
      helper.page_viewed_by_pet_owner?.should be_true
    end
  end
end
