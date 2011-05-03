class LoansController < ApplicationController

  before_filter :authenticate

  def create
    @artefact = Artefact.find(params[:loan][:artefact_id])
    start_date = params[:loan][:loan_start]
    end_date = params[:loan][:loan_end]
    current_user.loan!(@artefact, start_date, end_date)
    
    if current_user.loaned?(@artefact)
      inform_owner(@artefact)
      flash[:success] = "You have successfully made a request to loan artefact #{@artefact.artefactid} for the period of #{Date.parse(start_date.to_s).strftime("%a, %d %b %Y")} to #{Date.parse(start_date.to_s).strftime("%a, %d %b %Y")}. User #{@artefact.user.userid} will contact you shortly"
      # #{Date.parse(start_date).strftime("%a, %d %b %Y")}
      redirect_to root_path
    else
      flash[:error] = "There was an error with your request. Please try again later."
      redirect_to artefact_path(@artefact)
    end
  end

  def destroy
    @artefact = Loan.find(params[:id]).artefact_id
    current_user.unloan!(@artefact)
    redirect_to root_path
  end
  
  private

    def inform_owner(artefact)
      from = "jlj3l"
      to = "sfsdf"
      Pony.mail(:to => artefact.user.email, 
                :from => 'artefactsloanservice@example.com', 
                :subject => 'New loan request for #{artefact.artefactid}',
                :html_body => 'You have a new loan request for artefact #{artefact.artefactid} (#{from} - #{to})! <br /><br />
                                User: #{user.userid} <br/>
                                Name: #{user.firstname} #{user.lastname} <br />
                                Email: #{user.email} <br />
                                Address: #{user.address}, #{user.city}, #{user.postcode}, #{user.country} <br />
                                Mobile: #{user.mobile}<br/><br />
                                Please contact this user as soon as possible to arrange the loan details. <br /> <br />
                                Your Artefacts Loan Service', 
                :body =>        'You have a new loan request for artefact #{artefact.artefactid} (#{from} - #{to})!
                
                                                User: #{user.userid}
                                                Name: #{user.firstname} #{user.lastname}
                                                Email: #{user.email}
                                                Address: #{user.address}, #{user.city}, #{user.postcode}, #{user.country}
                                                Mobile: #{user.mobile}
                                                
                                Please contact this user as soon as possible to arrange the loan details.
                                Your Artefacts Loan Service',
                :via => :sendmail)
    end
  
end