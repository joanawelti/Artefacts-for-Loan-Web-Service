module LoansHelper
  def get_loan_start_date
    Date.today
  end

  def get_loan_end_date(start_date)
    start_date + 1.month
  end
  
  def loan_end_date(artefact)
    Loan.where(['artefact_id = ? AND active = ?', artefact.id, true]).first.loan_end
  end

end