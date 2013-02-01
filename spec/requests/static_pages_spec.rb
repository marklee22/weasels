require 'spec_helper'

describe "StaticPages" do
  subject { page }
  
  describe "Home Page" do
    before { visit root_path }
    it { should have_selector('title', text: 'Home') }
    it { should have_selector('h1', text: 'Home') }
    
    describe "when clicking Help link" do
      before { click_link 'Help' }
      it { should have_selector('title', text: 'Help') }
    end

    describe "when clicking About link" do
      before { click_link 'About' }
      it { should have_selector('title', text: 'About') }
    end
    
    describe "when clicking Contact Us link" do
      before { click_link 'Contact Us' }
      it { should have_selector('title', text: 'Contact Us') }
    end
    
    describe "when clicking Sign Up button" do
      before { click_link 'Sign Up Now' }
      it { should have_selector('title', text: 'Sign Up') }
    end    
  end
  
  describe "Help" do
    before { visit help_path }
    it { should have_selector('title', text: 'Help') }  
    it { should have_selector('h1', text: 'Help') }  
  end
  
  describe "About" do
    before { visit about_path }
    it { should have_selector('title', text: 'About') }
    it { should have_selector('h1', text: 'About') }
  end
  
  describe "Contact Us" do
    before { visit contact_path }
    it { should have_selector('title', text: 'Contact Us') }
    it { should have_selector('h1', text: 'Contact Us') }
  end
  
end
