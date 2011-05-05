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
  has_many :reverse_loans,  :foreign_key => "artefact_id",
                            :class_name => "Loan"
  has_many :loaners, :through => :reverse_loans, :source => :user
  has_many :comments, :dependent => :destroy
  
  
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
    :default_url => "/images/empty_:style.png",
    :styles => {
      :thumb=> "100x100#",
      :small  => "200x200",
      :url => "/images/:attachment/:id_:style.:extension",
      :path => ":rails_root/public/images/:attachment/:id_:style.:extension"
  }
  
  ## hooks
  before_create :make_artefactid
  
  def current_loan
    current = reverse_loans.where(['active = ?', true])
    current.first unless current.blank?
  end
  
  def is_on_loan?
    !current_loan.nil?
  end
  
  def unloan!
    reverse_loans.where(['active = ?', true]).first.update_attributes({ :loan_end => Date.current, :active => false  })
  end
  
  def get_current_location
    if is_on_loan?
      # get loaners location
      @owner = self.current_loan.user
    else
      # owner's location
      @owner = self.user
    end
    { :lat => @owner.lat, :long => @owner.long }
  end
  
  private
  
    # artefactid
    def make_artefactid
      self.artefactid = 'a' + Time.new.strftime("%y") + name[0,2].downcase + Artefact.count.to_s
    end
  
  
end
