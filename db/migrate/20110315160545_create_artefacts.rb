class CreateArtefacts < ActiveRecord::Migration
  def self.up
    create_table :artefacts do |t|
      t.string :artefactid
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :artefacts
  end
end
