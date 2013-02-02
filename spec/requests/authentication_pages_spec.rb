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
      it { should have_selector('title', text: 'Edit User') }
      
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
    describe "for non-signed in users" do
      describe "in Users controller" do      
        describe "visiting user edit page" do
          before { visit edit_user_path user }
          it { should have_selector('title', text: 'Sign In') }
        end
      
        describe "visiting users page" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign In') }
        end
      
        describe "submitting put to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end
      
    describe "as wrong user" do
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@test.com") }
      before { sign_in user }
      
      describe "editting other user" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: 'Edit User') }
      end
      
      pending "submitting put to the wrong user" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
      
      pending "submitting delete to the wrong user" do
        before { delete user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end
