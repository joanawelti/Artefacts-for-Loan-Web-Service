class AddGoogleMapsAttributeToUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :lat, :float
    change_column :users, :long, :float
    add_column :users, :gmaps, :boolean
  end

  def self.down
    change_column :users, :lat, :double
    change_column :users, :long, :double
    remove_column :users, :gmaps
  end
end
