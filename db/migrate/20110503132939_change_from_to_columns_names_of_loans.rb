class ChangeFromToColumnsNamesOfLoans < ActiveRecord::Migration
  def self.up
    rename_column :loans, :from, :loan_start
    rename_column :loans, :to, :loan_end
  end

  def self.down
    rename_column :loans, :loan_start, :from
    rename_column :loans, :loan_end, :to
  end
end
