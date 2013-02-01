require 'spec_helper'

describe "Users" do

  subject { page }

  describe "Sign Up" do
    let(:submit) { "Register" }
    before { visit signup_path }
    
    it { should have_selector('title', text: 'Sign Up') }
    it { should have_selector('h1', text: 'Sign Up') }
    it { should have_field('First Name') }
    it { should have_field('Last Name') }
    it { should have_field('Email') }
    it { should have_field('Password') }
    it { should have_field('Confirmation') }
    it { should have_button('Register') }
    
    describe "with valid information" do
      before do
        fill_in "First Name", with: "Mark"
        fill_in "Last Name", with: "Lee"
        fill_in "Email", with: "MarkLee805@gmail.com"
        fill_in "Password", with: "password"
        fill_in "Confirmation", with: "password"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after hitting submit" do
        before { click_button submit }
        it { should have_selector('title', text: 'Home') }
        it { should have_selector('div.alert-success', text: 'Success') }
        it { should have_link('Sign Out') }
        it { should_not have_link('Sign In') }
      end    
    end
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.to_not change{ User.count }
      end
      
      describe "after hitting submit" do
        before { click_button submit }
        it { should have_selector('div', id:'error_explanation') }
        it { should have_selector('title', text: 'Sign Up') }
      end
    end
  end
end
