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
  
  attr_accessor :password
  attr_accessible :firstname, :lastname, :email, :address, :city, :postcode, :country, :mobile, :password, :password_confirmation
  
  validates :firstname,  :presence => true,
                          :length   => { :maximum => 25 }
  
  validates :lastname,   :presence => true,
                          :length   => { :maximum => 25 }
                                                    
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,   :presence => { :in => true, :message => " address needs to be provided" }, 
                      :length => { :maximum => 50 },
                      :format => { :with => email_regex, :message => " address needs to have correct format, e.g john@example.com"},
                      :uniqueness => { :case_sensitive => false }
                      
  validates :address, :presence => true
  validates :city, :presence => true
  validates :postcode, :presence => true
  validates :country, :presence => true
  validates :password,  :presence => true, 
                        :confirmation => true,
                        :length       => { :within => 6..20, :message => " needs to have between 6 and 20 characters" }
  
  phone_regex = /^[+\/\-() 0-9]+$/x
  validates :mobile,    :presence     => true,
                        :format => { :with => phone_regex, :message => "Mobile number contains non-digits"}
                        
              
                        
  before_save :encrypt_password
  before_save :make_userid
  
  def self.authenticate(email, submitted_password) 
    user = find_by_email(email)
    return nil if user.nil? or !user.has_password?(submitted_password)
    return user
  end
  
  def self.authenticate_with_salt(id, salt)
    user = find_by_id(id)
    (user && user.salt == salt) ? user : nil
  end
  
  
   # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
   
  
  private
    # password
    def encrypt_password
        self.salt = make_salt if new_record?
        self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
        secure_hash("#{salt}--#{string}")
    end

    def make_salt
        secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
        Digest::SHA2.hexdigest(string)
    end  
    
    # userid
    def make_userid
      self.userid = 'u' + Time.new.strftime("%y") + firstname[0,1].downcase + lastname[0,1].downcase + User.count.to_s
    end
  
end
