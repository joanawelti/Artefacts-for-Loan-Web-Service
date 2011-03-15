class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :userid
      t.string :firstname
      t.string :lastname
      t.string :email
      t.boolean :administrator
      t.string :address
      t.string :city
      t.string :postcode
      t.string :country
      t.string :mobile

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
