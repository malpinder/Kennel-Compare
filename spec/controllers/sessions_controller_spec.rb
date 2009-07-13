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
        Owner.stub(:existing_owner_account).and_return(@oldowner)
        post :create, post_owner_data
      end

      describe 'with valid details' do
        before do
          Owner.stub(:valid_owner_account).and_return(@oldowner)
          post :create, post_owner_data
        end
        it 'should add the id to the session'  do
          session[:user_id].should == @oldowner.id
        end
        it 'should store the account type in the session' do
          session[:user_type].should == 'owners'
        end
        it 'should redirect to the owner home page' do
          response.should redirect_to("http://test.host/owners/#{@oldowner.id}")
        end
      end

      describe 'with invalid details' do

        before do
          Owner.stub(:existing_owner_account).and_return(nil)
          post :create, {:account => {:type => 'owner', :first_name => 'in', :surname => 'valid', :password => 'wrong'}}
        end

        it 'should return a warning' do
          flash[:warning].should_not be_nil
        end
        it 'should return to the login page' do
          response.should redirect_to('http://test.host/session/new')
        end
        it 'should not log the user in' do
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
        Kennel.should_receive(:valid_kennel_account)
        post :create, post_kennel_data
      end

      describe 'with a valid account' do
        before do
          Kennel.stub!(:valid_kennel_account).and_return(@oldkennel)
          post :create, post_kennel_data
        end
        it 'should add the id to the session'  do          
          session[:user_id].should == @oldkennel.id
        end
        it 'should store the account type in the session' do
          session[:user_type].should == 'kennels'
        end
        it 'should redirect to the kennel home page' do
          response.should redirect_to("http://test.host/kennels/#{@oldkennel.id}")
        end
      end

      describe 'with invalid details' do

        before do
          Kennel.stub(:valid_kennel_account).and_return(nil)
          post :create, post_kennel_data
        end

        it 'should return a warning' do
          flash[:warning].should_not be_nil
        end
        it 'should return to the login page' do
          response.should redirect_to('http://test.host/session/new')
        end
        it 'should not log the user in' do
          session[:user_id].should be_nil
        end

      end
    end
  end
  describe "DELETE destroy" do
    before do
      session[:user_id] = '1'
      session[:user_type] = 'owners'
      delete :destroy
    end
    it 'should set the session id to nil' do
      session[:user_id].should be_nil
    end
    it 'should set the session user type to nil' do
      delete :destroy
      session[:user_type].should be_nil
    end
    it 'should add a notice to the flash' do
      flash[:notice].should_not be_nil
    end
    it 'should redirect to the login page' do
      response.should redirect_to new_session_path
    end
  end
end
