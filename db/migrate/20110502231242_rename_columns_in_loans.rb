class RenameColumnsInLoans < ActiveRecord::Migration
  def self.up
    rename_column :loans, :loaner_id, :user_id
    rename_column :loans, :loaned_id, :artefact_id
  end

  def self.down
    rename_column :loans, :user_id, :loaner_id
    rename_column :loans, :artefact_id, :loaned_id
  end
end
