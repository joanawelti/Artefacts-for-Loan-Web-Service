# t.integer :loaner_id
# t.integer :loaned_id
# t.date :loan_start
# t.date :loan_end

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
    
    ## hooks
    after_create :update_artefact
    before_destroy :reset_artefact
    
    private
      def update_artefact
        self.artefact.update_attributes(:available => false)
      end
      
      def reset_artefact
        self.artefact.update_attributes(:available => true)
      end
    
end
