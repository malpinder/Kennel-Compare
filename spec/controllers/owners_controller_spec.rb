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
        post :create, {:owner => { :first_name => 'invalid', :surname => 'test', :password => 'testpass', :password_confirmation => 'testpass', :email => 'test@test.com'}}
        response.should render_template(:new)
      end

    end
  end

  describe 'GET edit' do
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
end
