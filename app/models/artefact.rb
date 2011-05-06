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
  attr_accessible :name, :description, :photo, :visible, :lat, :long
  
  ## validations
  validates :name,  :presence => true,
                    :length   => { :maximum => 200 }
  
  validates :user_id, :presence => true
  
  validates_numericality_of :lat,  :greater_than_or_equal_to => -90.0, 
                                        :less_than_or_equal_to => 90.0, 
                                        :allow_nil => true, 
                                        :message => "Value for lattitude must be in [-90, 90]"
  validates_numericality_of :long, :greater_than_or_equal_to => -180.0, 
                                        :less_than_or_equal_to => 180.0, 
                                        :allow_nil => true, 
                                        :message => "Value for longitude must be in [-180, 190]"
  
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
  
  
  def self.search(search_string)
    content = "%#{search_string}%"
    Artefact.where(['visible = ? AND (name LIKE ? OR description LIKE ? OR artefactid LIKE ?)', true, content, content, content])
  end
  
  def current_loan
    current = reverse_loans.where(['active = ?', true])
    current.first unless current.blank?
  end
  
  def loaner?(user)
    !loaners.find_by_id(user).blank?
  end
  
  def is_on_loan?
    !current_loan.nil?
  end
  
  def unloan!
    reverse_loans.find_by_active(true).update_attributes({ :loan_end => Date.current, :active => false  })
  end
  
  def get_current_location
    if is_on_loan?
      # get loaners location
      { :lat => self.current_loan.user.lat, :long => self.current_loan.user.long }
    else
      # does artefact have it's own location?
      if !(self.lat.nil? or self.long.nil?)
        { :lat => self.lat, :long => self.long }
      else
      # owner's location
        { :lat => self.user.lat, :long => self.user.long }
      end
    end
    
  end
  
  private
  
    # artefactid
    def make_artefactid
      self.artefactid = 'a' + Time.new.strftime("%y") + name[0,2].downcase + Artefact.count.to_s
    end
  
  
end
