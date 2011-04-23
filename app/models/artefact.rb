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
  attr_accessible :name, :description, :photo, :visible
  
  validates :name,  :presence => true,
                    :length   => { :maximum => 200 }
  
  validates :user_id, :presence => true
                         
  belongs_to :user
  
  default_scope :order => 'artefacts.name ASC'
  
  # Paperclip
  has_attached_file :photo,
    :default_url => "/images/rails.png",
    :styles => {
      :thumb=> "100x100#",
      :small  => "300x300",
      :url => "/images/:attachment/:id_:style.:extension",
      :path => ":rails_root/public/images/:attachment/:id_:style.:extension"
  }
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  
  before_save :make_artefactid
  
  private
  
    # artefactid
    def make_artefactid
      self.artefactid = 'a' + Time.new.strftime("%y") + name[0,2].downcase + Artefact.count.to_s
    end
  
  
end
