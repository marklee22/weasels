class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation
  before_save :create_remember_token
  before_save { |user| user.email = email.downcase }

  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, :presence => true, :uniqueness => { :case_sensitive => false },
    length: { :maximum => 254 }, :format => { :with => VALID_EMAIL_REGEX }
  validates :first_name, :presence => true, length: { :maximum => 35 }
  validates :last_name, :presence => true, length: { :maximum => 35 }
  validates :password, :presence => true, length: { :minimum => 6 }
  validates :password_confirmation, :presence => true
  
  private
    def create_remember_token
      begin
        self.remember_token = SecureRandom.urlsafe_base64
      end while self.class.exists?(:remember_token => remember_token)
    end  
end
