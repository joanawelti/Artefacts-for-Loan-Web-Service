module LoansHelper
  def get_loan_start_date
    Date.today
  end

  def get_loan_end_date(start_date)
    start_date + 1.month
  end
  
  def is_on_loan(artefact)
    !Loan.where(['artefact_id = ? AND loan_start <= ? AND loan_end >= ?', artefact.id, Date.current, Date.current]).blank?
  end
  
  def loan_end_date(artefact)
    Loan.where(['artefact_id = ? AND loan_start <= ? AND loan_end >= ?', artefact.id, Date.current, Date.current]).first.loan_end
  end

end