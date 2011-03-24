class AddDefaultAdminValueToUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :administrator, :boolean, :default => false
  end

  def self.down
  end
end
