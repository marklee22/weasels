require 'spec_helper'

describe "AuthenticationPages" do

  subject { page }
  let(:user) { FactoryGirl.create(:user) }  

  describe "Visit Sign In Path" do
    before { visit signin_path }
    it { should have_selector('title', text: 'Sign In') }
    it { should have_selector('h1', text: 'Sign In') }
    it { should have_link('Sign up here') }

    describe "with valid information" do
      before do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_button 'Sign In'
      end
      it { should have_css('div.alert-success', text: 'Success') }
      it { should have_link('Sign Out') }
      
      describe "clicking Sign Out" do
        before { click_link 'Sign Out' }
        it { should have_selector('div.alert-notice', text:'Signed Out') }
        it { should have_selector('title', text: 'Home') }
      end
    end

    describe "with invalid information" do
      before { click_button "Sign In" }
      it { should have_css('div.alert-error', text: 'Invalid') }
      
      describe "visit another page" do
        before { click_link "Home" }
        it { should_not have_css('div.alert-error', text: 'Invalid') }
      end
    end
  end
  
  describe "Authorization" do
    describe "in Users controller" do      
      describe "when user not signed in" do 
        describe "visiting user edit page" do
          before { visit edit_user_path user }
          it { should have_selector('title', text: 'Sign In') }
        end
        
        describe "visiting users page" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign In') }
        end
      end
    end
  end
end
