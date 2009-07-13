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

end
