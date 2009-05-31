class CreateOwners < ActiveRecord::Migration
  def self.up
    create_table :owners do |t|
      t.string :first_name
      t.string :surname
      t.string :email

      t.string :crypted_password
      t.string :salt


      t.timestamps
    end
  end

  def self.down
    drop_table :owners
  end
end
