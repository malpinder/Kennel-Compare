require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe KennelsController do
  describe 'GET new' do
    it 'should create a new kennel object' do
      kennel = mock_model(Kennel)
      Kennel.should_receive(:new).and_return(kennel)
      get :new
    end
  end

  describe 'POST create' do
    def post_data
      {:kennel => {:kennel_name => 'test', :address => 'test', :postcode => 'A1 1AA', :password => 'testpass', :password_confirmation => 'testpass', :email => 'test@test.com'}}
    end

    before do
      @kennel = mock_model(Kennel, {:valid? => true, :save => true})
      Kennel.stub!(:new).and_return(@kennel)
    end

    it 'should create a new kennel with params[:kennel]' do
      Kennel.should_receive(:new).and_return(@kennel)
      post :create, post_data
    end

    it 'should check that the details are valid' do
      @kennel.should_receive :valid?
      post :create, post_data
    end

    describe 'when the details are valid' do
      it 'should save the kennel' do
        @kennel.should_receive :save
        post :create, post_data
      end

      it 'should redirect to the kennel account page' do
        post :create, post_data
        response.should redirect_to("http://test.host/kennels/#{@kennel.id}")
      end

      it 'should log the kennel in' do
        post :create, post_data
        session[:user_id].should == @kennel.id
      end
      it 'should log them in as a kennel' do
        post :create, post_data
        session[:user_type].should == 'kennels'
      end
    end

    describe 'when the details are invalid' do
      it 'should render :new' do
        @kennel = mock_model(Kennel, {:valid? => false, :save => false})
        Kennel.stub!(:new).and_return(@kennel)
        post :create, {:kennel => {:kennel_name => 'invalid', :address => 'test', :postcode => 'invalid', :password => 'testpass', :password_confirmation => 'invalid', :email => 'invalid'}}
        response.should render_template(:new)
      end

    end
  end

  describe 'GET show' do
    it 'should find the kennel specified in the params' do
      Kennel.should_receive(:find).with('1')
      get :show, :id => '1'
    end
  end

  describe 'GET edit' do
    before do
      Kennel.stub(:find).and_return(Kennel.new)
      controller.stub(:ensure_logged_in_user).and_return(true)
      controller.stub(:ensure_authorised_kennel).and_return(true)
    end
    it 'should require a logged in user to access' do
      controller.should_receive(:ensure_logged_in_user)
      get :edit, :id => 1
    end
    it 'should require an authorised owner to access' do
      controller.should_receive(:ensure_authorised_kennel).with('1')
      get :edit, :id => 1
    end
    it 'should load up the owner details specified in the params' do
      kennel = mock_model(Kennel)
      Kennel.should_receive(:find).and_return(kennel)
      get :edit, :id => 1
    end
  end

  describe 'POST update' do
    def post_data
      {:kennel => {:password => 'newpass', :password_confirmation => 'newpass'}, :id => '1'}
    end

    before do
      @kennel = mock_model(Kennel, {:valid? => true, :update_attributes => true})
      Kennel.stub!(:find).and_return(@kennel)
      controller.stub(:ensure_logged_in_user).and_return(true)
      controller.stub(:ensure_authorised_kennel).and_return(true)
    end

    it 'should require a logged in user to access' do
      controller.should_receive(:ensure_logged_in_user)
      post :update, post_data
    end
    it 'should require an authorised owner to access' do
      controller.should_receive(:ensure_authorised_kennel).with('1')
      post :update, post_data
    end

    it 'should load up the kennel details specified in the params' do
      Kennel.should_receive(:find).and_return(@kennel)
      post :update, post_data
    end

    describe 'with valid details' do
      it 'should update the kennel' do
        @kennel.should_receive :update_attributes
        post :update, post_data
      end

      it 'should redirect to the kennel account page' do
        post :update, post_data
        response.should redirect_to(kennel_path(@kennel.id))
      end
    end
    describe 'with invalid details' do
      it 'should redirect back to the edit page' do
        @kennel = mock_model(Kennel, {:valid? => false, :update_attributes => false})
        Kennel.stub!(:find).and_return(@kennel)
        post :update, {:kennel => {:password => 'newpass', :password_confirmation => 'invalid'}}
        response.should redirect_to(edit_kennel_path(@kennel))
      end
    end
  end
end
