class CreateKennels < ActiveRecord::Migration
  def self.up
    create_table :kennels do |t|
      t.string :kennel_name
      t.string :address
      t.string :postcode
      t.string :email

      t.string :crypted_password
      t.string :salt

      t.timestamps
    end
  end

  def self.down
    drop_table :kennels
  end
end
