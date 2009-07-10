require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
describe ApplicationHelper do
  describe 'logged_in?' do
    it 'should return true if the session is storing an id' do
      session[:user_id] = '1'
      helper.logged_in?.should be_true
    end
    it 'should return false if the session is empty' do
      helper.logged_in?.should be_false
    end
  end

  describe 'current_user_name' do
    it 'should return the name of any owner who is logged in' do
      @user = mock_model(Owner, {:first_name => 'Anita', :surname => 'Dearly'})
      Owner.stub!(:find).and_return(@user)
      session[:user_id] = '1'
      session[:user_type] = 'owner'
      helper.current_user_name.should == 'Anita Dearly'
    end
    it 'should return the name of any kennel who is logged in' do
      @user = mock_model(Kennel, {:kennel_name => 'Doghouse'})
      Kennel.stub!(:find).and_return(@user)
      session[:user_id] = '1'
      session[:user_type] = 'kennel'
      helper.current_user_name.should == 'Doghouse'
    end
    it 'should return nil if there is no one logged in' do
      helper.current_user_name.should be_nil
    end
  end

 
end
