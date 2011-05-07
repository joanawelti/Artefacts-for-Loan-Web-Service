# == Loan
#
# Table name: loans
#
# Loan records should require:
# * loan_start  :date
# * loan_end    :date
# * artefact_id :integer => artefact being loaned
# * user_id     :integer => user that loans artefact
#
# Optional:
# * active    :boolean => loans that are not yet returned are active, finished ones are not active anymore 
#

class Loan < ActiveRecord::Base
        
    attr_accessible :artefact_id, :loan_start, :loan_end, :active
    
    validates :user_id, :presence => true
    validates :artefact_id, :presence => true
    
    validates :loan_end, :presence => true
    validates :loan_start, :presence => true
    validates_date :loan_start, :between => [ lambda{ 1.day.ago }, lambda{ Date.today } ]
    validates_date :loan_end, :between => [ lambda{ 1.day.ago }, lambda{ 1.month.since } ]
    
    ## relationships
    belongs_to :user
    belongs_to :artefact
        
    default_scope :order => 'loans.created_at DESC'
    
end
