class LoansController < ApplicationController

  before_filter :authenticate

  def create
    @artefact = Artefact.find(params[:loan][:loaned_id])
    current_user.loan!(@artefact)
    redirect_to root_path
  end

  def destroy
    @artefact = Loan.find(params[:id]).loaned
    current_user.unloan!(@artefact)
    redirect_to root_path
  end
  
end