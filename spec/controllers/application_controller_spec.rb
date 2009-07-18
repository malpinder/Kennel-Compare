require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
  describe 'logged_in?' do
    it 'should return true if the session is storing an id' do
      session[:user_id] = '1'
      controller.logged_in?.should be_true
    end
    it 'should return false if the session is empty' do
      session[:user_id] = nil
      controller.logged_in?.should be_false
    end
  end
  describe 'page_viewed_by_authorised_user?' do
    it 'should accept two arguments' do
      lambda{ controller.page_viewed_by_authorised_user?('owner', '1') }.should_not raise_error
    end
    it 'should accept one argument' do
      lambda{ controller.page_viewed_by_authorised_user?('owner') }.should_not raise_error
    end
    it 'should accept no arguments' do
      lambda{ controller.page_viewed_by_authorised_user? }.should_not raise_error
    end
    describe 'when using the default values' do
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

  describe 'ensure_logged_in_user' do
    it 'should return true if a user is logged in' do
      session[:user_id] = '1'
      session[:user_type] = 'owners'
      controller.ensure_logged_in_user.should be_true
    end
    it 'should return false if no-one is logged in' do
      controller.stub(:redirect_to)
      controller.ensure_logged_in_user.should be_false
    end
    it 'should redirect to the log in page if no-one is logged in' do
      controller.should_receive(:redirect_to).with(new_session_path)
      controller.ensure_logged_in_user
    end
  end

  describe 'ensure_authorised_owner' do
    before do
      controller.stub(:ensure_authorised_user)
    end
    it 'should accept one argument' do
      lambda{ controller.ensure_authorised_owner('1') }.should_not raise_error
    end
    it 'should fail with no arguments' do
      lambda{ controller.ensure_authorised_owner }.should raise_error
    end
    it 'should call ensure_authorised_user and pass it the correct arguments' do
      controller.should_receive(:ensure_authorised_user).with('owners', '1')
      controller.ensure_authorised_owner('1')
    end
  end

  describe 'ensure_authorised_kennel' do
    before do
      controller.stub(:ensure_authorised_user)
    end
    it 'should accept one argument' do
      lambda{ controller.ensure_authorised_kennel('1') }.should_not raise_error
    end
    it 'should fail with no arguments' do
      lambda{ controller.ensure_authorised_kennel }.should raise_error
    end
    it 'should call ensure_authorised_user and pass it the correct arguments' do
      controller.should_receive(:ensure_authorised_user).with('kennels', '1')
      controller.ensure_authorised_kennel('1')
    end
  end

  describe 'ensure_authorised_user' do
    before do
      controller.stub(:redirect_to)
    end
    it 'should accept two arguments' do
      lambda{ controller.ensure_authorised_user('owners', '1') }.should_not raise_error
    end
    it 'should accept one argument' do
      lambda{ controller.ensure_authorised_user('owners') }.should_not raise_error
    end
    it 'should accept no arguments' do
      lambda{ controller.ensure_authorised_user }.should_not raise_error
    end
    describe 'with an unauthorised user' do
      before do
        controller.stub(:page_viewed_by_authorised_user?).and_return(false)
      end
      it 'should add a warning to the flash' do
        controller.ensure_authorised_user
        flash[:warning].should_not be_nil
      end
      it 'should redirect to the correct account edit page, if they are logged in' do
        controller.stub(:logged_in?).and_return(true)
        session[:user_id] = 1
        session[:user_type] = 'kennels'
        controller.should_receive(:redirect_to).with(edit_kennel_path(1))
        controller.ensure_authorised_user
      end
      it 'should redirect to the login page if they are not logged in' do
        controller.stub(:logged_in?).and_return(false)
        controller.should_receive(:redirect_to).with(new_session_path)
        controller.ensure_authorised_user
      end
      it 'should return false' do
        controller.stub(:logged_in?).and_return(false)
        controller.ensure_authorised_user.should be_false
      end
    end
    describe 'with an authorised user' do
      before do
        controller.stub(:page_viewed_by_authorised_user?).and_return(true)
      end
      it 'should return true' do
        controller.ensure_authorised_user.should be_true
      end
    end
  end
end