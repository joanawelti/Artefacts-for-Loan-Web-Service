# == Schema Information
# Schema version: 20110315160545
#
# Table name: artefacts
#
#  id          :integer         not null, primary key
#  artefactid  :string(255)
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Artefact < ActiveRecord::Base
  attr_accessible :name, :description
  
  validates :name,  :presence => true,
                    :length   => { :maximum => 200 }
  
  validates :user_id, :presence => true
                         
  belongs_to :user
  
  default_scope :order => 'artefacts.name ASC'
end
