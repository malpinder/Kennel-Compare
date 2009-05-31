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
        session[:user_type].should == 'owner'
      end
    end

    describe 'when the details are invalid' do
      it 'should render :new' do
        @owner = mock_model(Owner, {:valid? => false, :save => false})
        Owner.stub!(:new).and_return(@owner)
        post :create, {:owner => { :first_name => 'test', :surname => 'test', :password => 'testpass', :password_confirmation => 'testpass', :email => 'test@test.com'}}
        response.should render_template(:new)
      end

    end
  end

end
