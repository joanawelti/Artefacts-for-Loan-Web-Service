class AddDefaultValueToVisibleArtefacts < ActiveRecord::Migration
  def self.up
    change_column :artefacts, :visible, :boolean, :default => true
  end

  def self.down
  end
end
