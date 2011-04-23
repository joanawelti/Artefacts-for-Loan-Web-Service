class AddCoordinatesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :long, :double
    add_column :users, :lat, :double
  end

  def self.down
    remove_column :users, :lat
    remove_column :users, :long
  end
end
