class Kennel < ActiveRecord::Base
  require 'digest/sha1'

  attr_accessor :password
  attr_protected :salt

  validates_presence_of :kennel_name
  validates_presence_of :address

  validates_presence_of :postcode
  validates_format_of :postcode, :with => /^([A-PR-UWYZ0-9][A-HK-Y0-9][AEHMNPRTVXY0-9]?[ABEHMNPRVWXY0-9]? {1,2}[0-9][ABD-HJLN-UW-Z]{2}|GIR 0AA)$/i, :allow_nil => true
  validates_uniqueness_of :postcode

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

  def self.existing_kennel_account(attrs)
    name = attrs[:kennel_name]
    postcode = attrs[:postcode]
    @kennel = Kennel.find_by_kennel_name_and_postcode(name, postcode)
    return nil if @kennel.nil?
    crypted_password = Digest::SHA1.hexdigest(attrs[:password]+@kennel.salt)
    return nil unless @kennel.crypted_password == crypted_password
    @kennel
  end
end
