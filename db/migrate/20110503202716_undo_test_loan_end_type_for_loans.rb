class UndoTestLoanEndTypeForLoans < ActiveRecord::Migration
  def self.up
    change_column :loans, :loan_end, :date
  end

  def self.down
    change_column :loans, :loan_end, :datetime
  end
end
