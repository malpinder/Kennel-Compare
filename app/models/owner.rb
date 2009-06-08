class Owner < ActiveRecord::Base
  require 'digest/sha1'

  attr_accessor :password
  attr_protected :salt

  validates_presence_of :first_name
  validates_presence_of :surname

  validates_presence_of :password
  validates_length_of :password, :in => 6..24, :allow_nil => true
  validates_confirmation_of :password, :allow_nil => true

  validates_presence_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :allow_nil => true

  before_save :add_salt, :encrypt_password

  def add_salt
    return if password.nil?

    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    string = ""
    1.upto(10)  {|i| string << chars[rand(chars.size-1)] }

    self.salt = string
  end

  def encrypt_password
    return if password.nil?
    self.crypted_password = Digest::SHA1.hexdigest(password+salt)
  end

  def self.valid_owner_account(attrs)
    first_name = attrs[:first_name]
    surname = attrs[:surname]
    @owner = Owner.find_by_first_name_and_surname(first_name, surname)
    return nil if @owner.nil?
    crypted_password = Digest::SHA1.hexdigest(attrs[:password]+@owner.salt)
    return nil unless @owner.crypted_password == crypted_password
    @owner
  end
end
