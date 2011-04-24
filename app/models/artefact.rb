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
  
  ## relationships
  belongs_to :user
  has_many :reverse_loans,  :foreign_key => "loaned_id",
                            :class_name => "Loan"
  has_many :loaners, :through => :reverse_loans
  
  
  ## attributes
  attr_accessible :name, :description, :photo, :visible
  
  ## validations
  validates :name,  :presence => true,
                    :length   => { :maximum => 200 }
  
  validates :user_id, :presence => true
  
  default_scope :order => 'artefacts.name ASC'
  
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  ## Paperclip
  has_attached_file :photo,
    :default_url => "/images/rails.png",
    :styles => {
      :thumb=> "100x100#",
      :small  => "300x300",
      :url => "/images/:attachment/:id_:style.:extension",
      :path => ":rails_root/public/images/:attachment/:id_:style.:extension"
  }
  
  ## hooks
  before_save :make_artefactid
  
  def loaner?(user)
    loans.find_by_loaner_id(user)
  end
  
  private
  
    # artefactid
    def make_artefactid
      self.artefactid = 'a' + Time.new.strftime("%y") + name[0,2].downcase + Artefact.count.to_s
    end
  
  
end
