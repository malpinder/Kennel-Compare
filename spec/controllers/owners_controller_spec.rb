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

  describe 'GET show' do
    it 'should find the owner specified in the params' do
      Owner.should_receive(:find).with('1')
      get :show, :id => '1'
    end
  end

  describe 'GET edit' do
    before do
      Owner.stub(:find).and_return(Owner.new)
      controller.stub(:ensure_logged_in_user).and_return(true)
      controller.stub(:ensure_authorised_user).and_return(true)
    end
    it 'should require a logged in user to access' do
      controller.should_receive(:ensure_logged_in_user)
      get :edit, :id => 1
    end
    it 'should require an authorised owner to access' do
      controller.should_receive(:ensure_authorised_owner).with('1')
      get :edit, :id => 1
    end

    it 'should load up the owner details specified in the params' do
      owner = mock_model(Owner)
      Owner.should_receive(:find).and_return(owner)
      get :edit, :id => 1
    end
  end

  describe 'POST update' do
    def post_data
      {:owner => {:password => 'newpass', :password_confirmation => 'newpass'}, :id => '1'}
    end

    before do
      @owner = mock_model(Owner, {:valid? => true, :update_attributes => true})
      Owner.stub!(:find).and_return(@owner)
      controller.stub(:ensure_logged_in_user).and_return(true)
      controller.stub(:ensure_authorised_owner).and_return(true)
    end

    it 'should require a logged in user to access' do
      controller.should_receive(:ensure_logged_in_user)
      post :update, post_data
    end
    it 'should require an authorised owner to access' do
      controller.should_receive(:ensure_authorised_owner).with('1')
      post :update, post_data
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
        response.should redirect_to(owner_path(@owner.id))
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
