require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WelcomeController do
  describe 'POST new' do
    it 'should send those who select Owner to the new owner page' do
      post :new, :account=>{:type => :owner}
      response.should redirect_to new_owner_path
    end
    it 'should send those who select Kennel to the new kennel page' do
      post :new, :account=>{:type => :kennel}
      response.should redirect_to new_kennel_path
    end
  end

end
