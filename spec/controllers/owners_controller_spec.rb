require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe OwnersController do
  describe 'GET new' do
    it 'should create a new owner object' do
      owner = mock_model(Owner)
      Owner.should_receive(:new).and_return(owner)
      get :new
    end
  end

  describe 'POST create' do

    def post_data
      {:owner => { :first_name => 'test', :surname => 'test', :password => 'testpass', :password_confirmation => 'testpass', :email => 'test@test.com'}}
    end

    before do
      @owner = mock_model(Owner, {:valid? => true, :save => true})
      Owner.stub!(:new).and_return(@owner)
    end

    it 'should create a new owner with params[:owner]' do
      Owner.should_receive(:new).and_return(@owner)
      post :create, post_data
    end

    it 'should check that the details are valid' do
      @owner.should_receive :valid?
      post :create, post_data
    end

    describe 'when the details are valid' do
      it 'should save the owner' do
        @owner.should_receive :save
        post :create, post_data
      end

      it 'should redirect to owner account page' do
        post :create, post_data
        response.should redirect_to("http://test.host/owners/#{@owner.id}")
      end

      it 'should log the owner in' do
        post :create, post_data
        session[:user_id].should == @owner.id
      end
      it 'should log them in as an owner' do
        post :create, post_data
        session[:user_type].should == 'owners'
      end
    end

    describe 'when the details are invalid' do
      it 'should render :new' do
        @owner = mock_model(Owner, {:valid? => false, :save => false})
        Owner.stub!(:new).and_return(@owner)
        post :create, {:owner => {:first_name => 'invalid', :surname => 'test', :password => 'testpass', :password_confirmation => 'testpass', :email => 'test@test.com'}}
        response.should render_template(:new)
      end

    end
  end

  describe 'GET edit' do
    before do
      @owner = mock_model(Owner)
      Owner.stub!(:find).and_return(@owner)
    end
    describe 'when viewed by the page owner' do
      before do
        session[:user_id] = '1'
        session[:user_type] = 'owners'
      end
      it 'should not redirect them anywhere else' do
        get :edit, :id => 1
        response.should_not redirect_to(new_session_path)
      end
      it 'should not add a warning to the flash' do
        get :edit, :id => 1
        flash[:warning].should be_nil
      end

      it 'should load up the owner details specified in the params' do
        owner = mock_model(Owner)
        Owner.should_receive(:find).and_return(owner)
        get :edit, :id => 1
      end
    end
    describe 'when viewed by a different user' do
      before do
        session[:user_id] = '2'
        session[:user_type] = 'owners'
      end
      it 'should redirect them to their own page' do
        get :edit, :id => 1
        response.should redirect_to owner_path(session[:user_id])
      end
      it 'should add a warning to the flash' do
        get :edit, :id => 1
        flash[:warning].should_not be_nil
      end
    end
    describe 'when viewed by a user who is not logged in' do
      it 'should redirect them to the login page' do
        get :edit, :id => 1
        response.should redirect_to new_session_path
      end
      it 'should add a warning to the flash' do
        get :edit, :id => 1
        flash[:warning].should_not be_nil
      end
    end
  end

  describe 'POST update' do
    def post_data
      {:owner => {:password => 'newpass', :password_confirmation => 'newpass'}}
    end

    before do
      @owner = mock_model(Owner, {:valid? => true, :update_attributes => true})
      Owner.stub!(:find).and_return(@owner)
    end

    describe 'when posted by someone who is not the authorised user' do
      before do
        controller.stub(:page_viewed_by_authorised_user?).and_return(false)
      end
      it 'should add a warning to the flash' do
        post :update, post_data
        flash[:warning].should_not be_nil
      end
      it 'should redirect to the correct account edit page, if they are logged in' do
        controller.stub(:logged_in?).and_return(true)
        session[:user_id] = 1
        session[:user_type] = 'kennels'
        post :update, post_data
        response.should redirect_to(edit_kennel_path(1))
      end
      it 'should redirect to the login page if they are not logged in' do
        controller.stub(:logged_in?).and_return(false)
        post :update, post_data
        response.should redirect_to(new_session_path)
      end
    end
    describe 'when posted by the authorised user' do
      before do
        controller.stub(:page_viewed_by_authorised_user?).and_return(true)
      end
      it 'should load up the owner details specified in the params' do
        Owner.should_receive(:find).and_return(@owner)
        post :update, post_data
      end

      describe 'with valid details' do
        it 'should update the owner' do
          @owner.should_receive :update_attributes
          post :update, post_data
        end

        it 'should redirect to owner account page' do
          post :update, post_data
          response.should redirect_to("http://test.host/owners/#{@owner.id}")
        end
      end

      describe 'with invalid details' do
        it 'should redirect back to the edit page' do
          @owner = mock_model(Owner, {:valid? => false, :update_attributes => false})
          Owner.stub!(:find).and_return(@owner)
          post :update, {:owner => {:password => 'newpass', :password_confirmation => 'invalid'}}
          response.should redirect_to(edit_owner_path(@owner))
        end
      end
    end
  end
end
