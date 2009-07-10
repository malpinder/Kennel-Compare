require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do

  describe 'POST create' do
    describe 'when logging in an owner' do
      before do
        @oldowner = Owner.create(:first_name => 'old', :surname => 'owner', :password => 'password', :email => 'valid@test.com')
      end

      def post_owner_data
        {:account => {:type => 'owner', :first_name => 'old', :surname => 'owner', :password => 'password'}}
      end

      it 'should ask the model if the owner exists' do
        owner = mock_model(Owner, :valid_owner_account => @oldowner)
        Owner.should_receive(:valid_owner_account).and_return(@oldowner)
        post :create, post_owner_data
      end

      describe 'with a valid account' do
        before do
          owner = mock_model(Owner, :valid_owner_account => @oldowner)
          Owner.stub!(:valid_owner_account).and_return(@oldowner)
        end
        it 'should add the id to the session'  do
          post :create, post_owner_data
          session[:user_id].should == @oldowner.id
        end
        it 'should store the account type in the session' do
          post :create, post_owner_data
          session[:user_type].should == 'owners'
        end
        it 'should redirect to the owner home page' do
          post :create, post_owner_data
          response.should redirect_to("http://test.host/owners/#{@oldowner.id}")
        end
      end

      describe 'with invalid details' do

        before do
          owner = mock_model(Owner, :valid_owner_account => nil)
          Owner.should_receive(:valid_owner_account).and_return(nil)
        end

        it 'should return a warning' do
          post :create, post_owner_data
          flash[:warning].should_not be_nil
        end
        it 'should return to the login page' do
          post :create, post_owner_data
          response.should redirect_to('http://test.host/session/new')
        end
        it 'should not log the user in' do
          post :create, post_owner_data
          session[:user_id].should be_nil
        end

      end
    end

    describe 'when logging in a kennel' do
      before do
        @oldkennel = Kennel.create(:kennel_name => 'old', :password => 'password', :email => 'valid@test.com', :address => 'test', :postcode => 'A1 1AA')
      end

      def post_kennel_data
        {:account => {:type => 'kennel', :kennel_name => 'old', :password => 'password'}}
      end

      it 'should ask the model if the kennel exists' do
        kennel = mock_model(Kennel, :valid_kennel_account => @oldkennel)
        Kennel.should_receive(:valid_kennel_account).and_return(@oldkennel)
        post :create, post_kennel_data
      end

      describe 'with a valid account' do
        before do
          kennel = mock_model(Kennel, :valid_kennel_account => @oldkennel)
          Kennel.stub!(:valid_kennel_account).and_return(@oldkennel)
        end
        it 'should add the id to the session'  do
          post :create, post_kennel_data
          session[:user_id].should == @oldkennel.id
        end
        it 'should store the account type in the session' do
          post :create, post_kennel_data
          session[:user_type].should == 'kennels'
        end
        it 'should redirect to the kennel home page' do
          post :create, post_kennel_data
          response.should redirect_to("http://test.host/kennels/#{@oldkennel.id}")
        end
      end

      describe 'with invalid details' do

        before do
          kennel = mock_model(Kennel, :valid_kennel_account => nil)
          Kennel.should_receive(:valid_kennel_account).and_return(nil)
        end

        it 'should return a warning' do
          post :create, post_kennel_data
          flash[:warning].should_not be_nil
        end
        it 'should return to the login page' do
          post :create, post_kennel_data
          response.should redirect_to('http://test.host/session/new')
        end
        it 'should not log the user in' do
          post :create, post_kennel_data
          session[:user_id].should be_nil
        end

      end
    end
  end
  describe "DELETE destroy" do
    it 'should set the session id to nil' do
      session[:user_id] = '1'
      delete :destroy
      session[:user_id].should be_nil
    end
    it 'should set the session user type to nil' do
      session[:user_type] = 'owners'
      delete :destroy
      session[:user_type].should be_nil
    end
    it 'should add a notice to the flash' do
      delete :destroy
      flash[:notice].should_not be_nil
    end
    it 'should redirect to the login page' do
      delete :destroy
      response.should redirect_to new_session_path
    end
  end
end
