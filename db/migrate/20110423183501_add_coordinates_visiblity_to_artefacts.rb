class AddCoordinatesVisiblityToArtefacts < ActiveRecord::Migration
  def self.up
    add_column :artefacts, :long, :double
    add_column :artefacts, :lat, :double
    add_column :artefacts, :visible, :boolean
  end

  def self.down
    remove_column :artefacts, :visible
    remove_column :artefacts, :lat
    remove_column :artefacts, :long
  end
end
