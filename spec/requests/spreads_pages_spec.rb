require 'spec_helper'

describe Spread do
  before { @spread = Spread.new(favored_team_id: 1, under_team_id: 2, spread: 10.0) }
  subject { page }
  
  describe "index" do
    before { visit spreads_path }
    
    it { should have_selector('title', text: 'Spreads') }
    it { should have_selector('h1', text: 'Spreads') }
    it { should have_content("Week #{NFL_WEEK} - #{NFL_YEAR}") }
    
    describe "with spreads for that week"
      it { should have_selector('table.table-striped') }
      
      describe "#"
      
      pending "should not have data from a different week" do
        before do
          # get 
        end
      end

      pending "should not have the same team in two spreads" do
      end
    end
    
    describe "uploading spreads" do
    end
    
    describe "editing spreads" do
    end
    
    describe "deleting spreads" do
    end    
  end
end