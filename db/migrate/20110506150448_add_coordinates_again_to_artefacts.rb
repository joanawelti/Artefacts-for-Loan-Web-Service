class AddCoordinatesAgainToArtefacts < ActiveRecord::Migration
  def self.up
    add_column :artefacts, :lat, :float
    add_column :artefacts, :long, :float
  end

  def self.down
    remove_column :artefacts, :long
    remove_column :artefacts, :lat
  end
end
