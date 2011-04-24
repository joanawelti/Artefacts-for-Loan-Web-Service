class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :content
      t.integer :artefact_id
      t.integer :user_id

      t.timestamps
    end
    add_index :comments, :artefact_id
  end

  def self.down
    drop_table :comments
  end
end
