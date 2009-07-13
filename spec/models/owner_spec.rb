require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Owner do
  def valid_owner_attributes
      { :first_name => 'test',
        :surname => 'test',
        :password => 'password',
        :password_confirmation => 'password',
        :email => 'valid@test.com'
      }
  end
  describe 'when accepting information from a user' do
    describe 'that is creating a new account' do
      before do
        @owner = Owner.new(valid_owner_attributes)
      end
      it 'should not allow :salt to be set' do
        @owner.attributes = {:salt => 'i_am_trying_to_set_my_salt'}
        @owner.salt.should_not == 'i_am_trying_to_set_my_salt'
      end
    end
    describe 'that is updating an existing account' do
      before do
        @owner = Owner.create(valid_owner_attributes)
      end
      it 'should not allow :salt to be set' do
        @owner.update_attributes(:salt => 'i_am_trying_to_set_my_salt')
        @owner.salt.should_not == 'i_am_trying_to_set_my_salt'
      end
      end
  end
  describe 'when saving new account' do
    before do
      @owner = Owner.new
    end
    it 'should not accept an account without a first name' do
      @owner.attributes = valid_owner_attributes.except(:first_name)
      @owner.should have(1).error_on(:first_name)
    end

    it 'should not accept an account without a surname' do
      @owner.attributes = valid_owner_attributes.except(:surname)
      @owner.should have(1).error_on(:surname)
    end

    it 'should not accept a user without a password' do
      @owner.attributes = valid_owner_attributes.except(:password)
      @owner.should have(1).error_on(:password)
    end

    it 'should not accept an account with a password shorter than 6 characters' do
      @owner.attributes = valid_owner_attributes
      @owner.password = 'short'
      @owner.password_confirmation = 'short'
      @owner.should have(1).error_on(:password)
    end

    it 'should not accept an account with a password greater than 24 characters' do
      @owner.attributes = valid_owner_attributes
      @owner.password = 'farfarfarfarfarfarfarfarfarfartoolong'
      @owner.password_confirmation = 'farfarfarfarfarfarfarfarfarfartoolong'
      @owner.should have(1).error_on(:password)
    end

    it 'should not accept an account with an uncomfirmed password' do
      @owner.attributes = valid_owner_attributes
      @owner.password_confirmation = 'notcorrect'
      @owner.should have(1).error_on(:password)
    end

    it 'should not accept an account without an email address' do
      @owner.attributes = valid_owner_attributes.except(:email)
      @owner.should have(1).error_on(:email)
    end

    it 'should not accept an account with an invalid email address' do
      @owner.attributes = valid_owner_attributes
      @owner.email = 'invalid'
      @owner.should have(1).error_on(:email)
    end

    it 'should accept an account with valid attributes' do
      @owner.attributes = valid_owner_attributes
      @owner.errors.should be_blank
    end
    it 'should generate a salt if the account is valid' do
      @owner.attributes = valid_owner_attributes
      @owner.save
      @owner.salt.should_not be_nil
    end
    it 'should store the password as a salted hash if the account is valid' do
      @owner.attributes = valid_owner_attributes
      @owner.save
      @owner.crypted_password.should_not be_nil
      @owner.crypted_password.should_not == @owner.password
    end
  end

  describe 'method existing_owner_account' do
    def valid_login_details
      {:first_name => 'test', :surname => 'test', :password => 'password'}
    end
    before do
      @owner = Owner.create(valid_owner_attributes)
    end
    it 'should check the db for the existence of the provided names' do
      Owner.should_receive :find_by_first_name_and_surname
      Owner.existing_owner_account(valid_login_details)
    end
    it 'should return nil if both names do not match an account' do
      Owner.existing_owner_account(:first_name => 'invalid', :surname => 'test', :password => 'password').should be_nil
    end
    it 'should return nil if the password does not match the account' do
      Owner.existing_owner_account(:first_name => 'test', :surname => 'test', :password =>'wrong').should be_nil
    end
    it 'should return the account if the names and password do match' do
      Owner.existing_owner_account(valid_login_details).should == @owner
    end
  end

end
