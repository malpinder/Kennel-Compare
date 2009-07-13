require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Kennel do
  def valid_kennel_attributes
      { :kennel_name => 'test',
        :address => 'test',
        :postcode => 'A1 1AA',
        :password => 'password',
        :password_confirmation => 'password',
        :email => 'valid@test.com'
      }
  end
  describe 'when accepting information from a user' do
    describe 'that is creating a new account' do
      before do
        @kennel = Kennel.new(valid_kennel_attributes)
      end
      it 'should not allow :salt to be set' do
        @kennel.attributes = {:salt => 'i_am_trying_to_set_my_salt'}
        @kennel.salt.should_not == 'i_am_trying_to_set_my_salt'
      end
    end
    describe 'that is updating an existing account' do
      before do
        @kennel = Kennel.create(valid_kennel_attributes)
      end
      it 'should not allow :salt to be set' do
        @kennel.update_attributes(:salt => 'i_am_trying_to_set_my_salt')
        @kennel.salt.should_not == 'i_am_trying_to_set_my_salt'
      end
    end
  end

  describe 'when saving new account' do

    before do
      @kennel = Kennel.new
    end

    it 'should not accept an account without a name' do
      @kennel.attributes = valid_kennel_attributes.except(:kennel_name)
      @kennel.should have(1).error_on(:kennel_name)
    end

    it 'should not accept an account without an address' do
      @kennel.attributes = valid_kennel_attributes.except(:address)
      @kennel.should have(1).error_on(:address)
    end

    it 'should not accept an account without a postcode' do
      @kennel.attributes = valid_kennel_attributes.except(:postcode)
      @kennel.should have(1).error_on(:postcode)
    end

    it 'should not accept an account with an existing postcode' do
      Kennel.create(valid_kennel_attributes)
      @kennel.attributes = valid_kennel_attributes
      @kennel.should have(1).error_on(:postcode)
    end

    it 'should not accept an account with an invalid postcode' do
      @kennel.attributes = valid_kennel_attributes.except(:postcode)
      @kennel.postcode = 'invalid'
      @kennel.should have(1).error_on(:postcode)
    end
    
    it 'should not accept an account without a password' do
      @kennel.attributes = valid_kennel_attributes.except(:password)
      @kennel.should have(1).error_on(:password)
    end

    it 'should not accept an account with a password shorter than 6 characters' do
      @kennel.attributes = valid_kennel_attributes
      @kennel.password = 'short'
      @kennel.password_confirmation = 'short'
      @kennel.should have(1).error_on(:password)
    end

    it 'should not accept an account with a password greater than 24 characters' do
      @kennel.attributes = valid_kennel_attributes
      @kennel.password = 'farfarfarfarfarfarfarfarfarfartoolong'
      @kennel.password_confirmation = 'farfarfarfarfarfarfarfarfarfartoolong'
      @kennel.should have(1).error_on(:password)
    end

    it 'should not accept an account with an uncomfirmed password' do
      @kennel.attributes = valid_kennel_attributes
      @kennel.password_confirmation = 'notcorrect'
      @kennel.should have(1).error_on(:password)
    end

    it 'should not accept an account without an email address' do
      @kennel.attributes = valid_kennel_attributes.except(:email)
      @kennel.should have(1).error_on(:email)
    end

    it 'should not accept an account with an invalid email address' do
      @kennel.attributes = valid_kennel_attributes
      @kennel.email = 'invalid'
      @kennel.should have(1).error_on(:email)
    end

    it 'should accept an account with valid attributes' do
      @kennel.attributes = valid_kennel_attributes
      @kennel.errors.should be_blank
    end
    it 'should generate a salt if the account is valid' do
      @kennel.attributes = valid_kennel_attributes
      @kennel.save
      @kennel.salt.should_not be_nil
    end
    it 'should store the password as a salted hash if the account is valid' do
      @kennel.attributes = valid_kennel_attributes
      @kennel.save
      @kennel.crypted_password.should_not be_nil
      @kennel.crypted_password.should_not == @kennel.password
    end
  end
  describe 'method valid_kennel_account' do
    before do
      @kennel = Kennel.create(valid_kennel_attributes)
    end
    it 'should check the db for the existence of the provided name and postcode' do
      Kennel.should_receive :find_by_kennel_name_and_postcode
      Kennel.valid_kennel_account(:kennel_name => 'test', :postcode => 'A1 1AA', :password => 'password')
    end
    it 'should return nil if name and postcode are invalid' do
      Kennel.valid_kennel_account(:kennel_name => 'invalid', :postcode => 'A1 1AA', :password => 'password').should be_nil
    end
    it 'should return nil if the names and password do not match' do
      Kennel.valid_kennel_account(:kennel_name => 'test', :postcode => 'A1 1AA', :password =>'wrong').should be_nil
    end
    it 'should return the account if the names and password do match' do
      Kennel.valid_kennel_account(:kennel_name => 'test', :postcode => 'A1 1AA', :password => 'password').should == @kennel
    end
  end
end
