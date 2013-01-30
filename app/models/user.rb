class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, :presence => true, :uniqueness => { :case_sensitive => false },
    length: { :maximum => 254 }, :format => { :with => VALID_EMAIL_REGEX }
  validates :first_name, :presence => true, length: { :maximum => 35 }
  validates :last_name, :presence => true, length: { :maximum => 35 }
  
end
