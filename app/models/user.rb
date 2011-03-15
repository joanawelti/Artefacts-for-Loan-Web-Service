# == Schema Information
# Schema version: 20110315160545
#
# Table name: users
#
#  id            :integer         not null, primary key
#  userid        :string(255)
#  firstname     :string(255)
#  lastname      :string(255)
#  email         :string(255)
#  administrator :boolean
#  address       :string(255)
#  city          :string(255)
#  postcode      :string(255)
#  country       :string(255)
#  mobile        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class User < ActiveRecord::Base
  
  attr_accessible :firstname, :lastname, :email, :address, :city, :postcode, :country, :mobile
  
  validates :firstname,  :presence => true,
                          :length   => { :maximum => 25 }
  
  validates :lastname,   :presence => true,
                          :length   => { :maximum => 25 }
                                                    
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,  :presence => true,
                      :length => { :maximum => 50 },
                      :format => { :with => email_regex},
                      :uniqueness => { :case_sensitive => false }
                      
  validates :address, :presence => true
  validates :city, :presence => true
  validates :postcode, :presence => true
  validates :country, :presence => true
  
end
