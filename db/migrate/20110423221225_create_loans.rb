class CreateLoans < ActiveRecord::Migration
  def self.up
    create_table :loans do |t|
      t.integer :loaner_id
      t.integer :loaned_id
      t.date :from
      t.date :to

      t.timestamps
    end
    add_index :loans, :loaner_id
    add_index :loans, :loaned_id
  end

  def self.down
    drop_table :loans
  end
end
