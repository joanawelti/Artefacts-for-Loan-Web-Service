class Loan < ActiveRecord::Base
        
    attr_accessible :loaned_id
    
    validates :loaner_id, :presence => true
    validates :loaned_id, :presence => true
    
    ## relationships
    belongs_to :loaner, :class_name => "User"
    belongs_to :loaned, :class_name => "Artefact"
    
end
