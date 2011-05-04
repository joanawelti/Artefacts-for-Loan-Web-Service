class AddActiveToLoans < ActiveRecord::Migration
  def self.up
    add_column :loans, :active, :boolean, :default => true
  end

  def self.down
    remove_column :loans, :active
  end
end
