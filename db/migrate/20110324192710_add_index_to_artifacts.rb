class AddIndexToArtifacts < ActiveRecord::Migration
  def self.up
    add_column :artefacts, :user_id, :integer
    add_index :artefacts, :user_id 
  end

  def self.down
    remove_column :artefacts, :user_id
    remove_index :artefacts, :user_id
  end
end
