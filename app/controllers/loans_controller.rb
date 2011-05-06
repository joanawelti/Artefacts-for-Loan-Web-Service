class LoansController < ApplicationController

  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy  
  before_filter :authenticate_admin, :only => [:index, :reorder]
  
  def index
    @title = "Active Loans"
    @loans = Loan.find_all_by_active(true).paginate(:page => params[:page])
  end

  def create
    @artefact = Artefact.find(params[:loan][:artefact_id])
    start_date = params[:loan][:loan_start]
    end_date = params[:loan][:loan_end]
    current_user.loan!(@artefact, start_date, end_date)
    
    if current_user.loaned?(@artefact)
      inform_owner(@artefact, start_date, end_date)
      inform_loaner(@artefact, start_date, end_date)
      flash[:success] = "You have successfully made a request to loan artefact #{@artefact.artefactid} for the period of #{Date.parse(start_date.to_s).strftime("%a, %d %b %Y")} to #{Date.parse(start_date.to_s).strftime("%a, %d %b %Y")} \n. User #{@artefact.user.userid} will contact you shortly"
    else
      flash[:error] = "There was an error with your request. Please try again later."    
    end
    redirect_to root_path
  end

  def destroy
    loan = Loan.find(params[:id])
    @artefact = Artefact.find(loan.artefact_id)
    @artefact.unloan!
    if !loan.user.loaned?(@artefact)
      flash[:success] = "Loan successfully ended"
    else 
      flash[:error] = "There was an error with your request. Please try again later."
    end
    redirect_to root_path
  end
  
  def reorder
    @order = params[:order]
    if @order.blank? or @order.to_i.abs > 2
      respond_to do |format|
        format.html { redirect_to :index }
        format.js
      end
    else
      if @order.to_i == 2
        puts "ASC"
        @loans = Loan.find_all_by_active(true).sort!{|a,b| a.created_at <=> b.created_at}.paginate(:page => params[:page])
        puts @loans.first.id
      else
        @loans = Loan.find_all_by_active(true).paginate(:page => params[:page])
      end
      respond_to do |format|
        format.html { render :index, :loans => @loans  }
        format.js
      end
    end
  end
  
  
  private
    def authorized_user
      @artefact = Artefact.find(Loan.find(params[:id]).artefact_id)
      redirect_to root_path unless current_user?(@artefact.user) or current_user.administrator?
    end

    def inform_loaner(artefact, start_date, end_date)
      Pony.mail(:to => current_user.email, 
                :from => 'artefactsloanservice@example.com', 
                :subject => 'Loan request for #{artefact.artefactid}',
                :html_body => 'You have just made a loan request for artefact #{artefact.artefactid} (#{start_date} - #{end_date}). <br />
                              The owner of this artefact will contact you shortly to arrange the hand over of the item.
                              <br /> <br />
                              Your Artefacts Loan Service', 
                :body =>      'You have just made a loan request for artefact #{artefact.artefactid} (#{start_date} - #{end_date}).
                              The owner of this artefact will contact you shortly to arrange the hand over of the item.
                              
                              Your Artefacts Loan Service',
                :via => :sendmail)
    end

    def inform_owner(artefact, start_date, end_date)
      Pony.mail(:to => artefact.user.email, 
                :from => 'artefactsloanservice@example.com', 
                :subject => 'New loan request for #{artefact.artefactid}',
                :html_body => 'You have a new loan request for artefact #{artefact.artefactid} (#{start_date} - #{end_date})! <br /><br />
                                User: #{user.userid} <br/>
                                Name: #{user.firstname} #{user.lastname} <br />
                                Email: #{user.email} <br />
                                Address: #{user.address}, #{user.city}, #{user.postcode}, #{user.country} <br />
                                Mobile: #{user.mobile}<br/><br />
                                Please contact this user as soon as possible to arrange the loan details. <br /> <br />
                                Your Artefacts Loan Service', 
                :body =>        'You have a new loan request for artefact #{artefact.artefactid} (#{start_date} - #{end_date})!
                
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