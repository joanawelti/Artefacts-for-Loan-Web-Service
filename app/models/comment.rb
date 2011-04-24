class Comment < ActiveRecord::Base
  
  ## attributes
  attr_accessible :content, :artefact_id
  
  ## validations
  validates :content, :presence => true,
                      :length   => { :maximum => 500 }
  validates :user_id, :presence => true
  validates :artefact_id, :presence => true
  
  ## relationships
  belongs_to :user
  belongs_to :artefact
  
  ## scope
  default_scope :order => 'comments.created_at DESC'
  
end
