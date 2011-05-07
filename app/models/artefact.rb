# == Artefact
#
# Table name: artefacts
#
# User records should require:
#  * name       :string
#  * user_id    :integer => association to user
#
#
# Optional:
# * description     :string
# * lat/long        :float => default location. Artefacts can have their own location if it is different from the owner's location, but this should seldom be the case. Added because of the project description 
# * photo. Managed by paperclip plugin. If no picture, default picture is used
# * visible    :boolean => if set to false, artefact can't be borrowed and doesn't show up for other users. Default is true
#
#
# Belongs to users, can have loaners and comments
#

class Artefact < ActiveRecord::Base
  
  ## relationships
  belongs_to :user
  has_many :reverse_loans,  :foreign_key => "artefact_id",
                            :class_name => "Loan",
                            :dependent => :destroy
                            
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
  
  ##
  # Returns artefacts that contain a string similar to search_string in their name, description or artefactid
  #
  def self.search(search_string)
    content = "%#{search_string}%"
    Artefact.where(['visible = ? AND (name LIKE ? OR description LIKE ? OR artefactid LIKE ?)', true, content, content, content])
  end
  
  ##
  # Returns the current loan or nil, if not loaned at the moment
  #
  def current_loan
    current = reverse_loans.find_by_active(true) 
    current unless current.blank?
  end
  
  ##
  # Returns true if user has ever been a borrower of artefact
  #
  def loaner?(user)
    !loaners.find_by_id(user).blank?
  end
  
  ##
  # Returns true if the artefact is currently loaned by a user
  #
  def is_on_loan?
    !current_loan.nil?
  end
  
  ##
  # Ends a loan and makes the artefact loanable again
  #
  def unloan!
    reverse_loans.find_by_active(true).update_attributes({ :loan_end => Date.current, :active => false  })
  end
  
  ##
  # Returns the current location of the artefact
  # If the artefact is on loan, this is the loaner's location, else the owner's or if available, 
  # the artefact's own location
  #
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
  
    ##
    # Creats and sets artefactid
    #
    def make_artefactid
      self.artefactid = 'a' + Time.new.strftime("%y") + name[0,2].downcase + Artefact.count.to_s
    end
  
  
end
