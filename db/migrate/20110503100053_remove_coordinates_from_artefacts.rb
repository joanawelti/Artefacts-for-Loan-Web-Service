class RemoveCoordinatesFromArtefacts < ActiveRecord::Migration
  def self.up
    remove_column :artefacts, :lat
    remove_column :artefacts, :long
  end

  def self.down
    add_column :artefacts, :lat
    add_column :artefacts, :long
  end
end
