require 'spec_helper'

describe User do
  before do
    @user = User.new(first_name: "Mark", last_name: "Lee", email: "MarkLee805@gmail.com",
      password: "password", password_confirmation: "password")
  end
  
  subject { @user }
  
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe "when first name is blank" do
    before { @user.first_name = " " }
    it { should_not be_valid }
  end
  
  describe "when last name is blank" do
    before { @user.last_name = " " }
    it { should_not be_valid }
  end
  
  describe "when email is blank" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when password is blank" do
    before { @user.password = " " }
    it { should_not be_valid }
  end
  
  describe "when password confirmation is blank" do
    before { @user.password_confirmation = ' ' }
    it { should_not be_valid }
  end
  
  describe "when password is nil" do
    before { @user.password = nil }
    it { should_not be_valid }
  end
  
  describe "when password is less than 6 characters long" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end
  
  describe "when password and password confirmation not equal" do
    before do
      @user.password = "password"
      @user.password_confirmation = "not_password"
    end
    it { should_not be_valid }
  end
  
  describe "when first name is over 35 characters" do
    before { @user.first_name = "a" * 36 }
    it { should_not be_valid }
  end
  
  describe "last name is over 35 characters" do
    before { @user.last_name = "a" * 36 }
    it { should_not be_valid }
  end
  
  describe "duplicate email address" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid }
  end
  
  describe "when email address is invalid" do
    it "should be an invalid format" do
      addresses = %w[test@test, test, test.test, test@test.com. test,@test.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
    describe "with over 254 characters" do
      before { @user.email = "a" * 246 + "@test.com" }
      it { should_not be_valid }
    end
  end
  
  describe "when email address if valid" do
    it "should be a valid format" do
      addresses = %w[test@test.com testing-test@test.com tester.test@test.com tester+test@test.com]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end
  

end
