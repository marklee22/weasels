require 'spec_helper'

describe Spread do
  before do
    @spread = Spread.new(favored_team_id: 1, under_team_id: 2, spread: 5, week: 1, year: 2012, favored_won: true)
  end
  
  subject { @spread }
  
  it { should respond_to(:favored_team_id) }
  it { should respond_to(:under_team_id) }
  it { should respond_to(:spread) }
  it { should respond_to(:week) }
  it { should respond_to(:year) }
  it { should respond_to(:favored_won) }
  it { should be_valid }
  
  describe "with favored team blank" do
    before { @spread.favored_team_id = "" }
    it { should_not be_valid }
  end
  
  describe "with under team blank" do
    before { @spread.under_team_id = "" }
    it { should_not be_valid }
  end
  
  describe "with spread blank" do
    before { @spread.spread = "" }
    it { should_not be_valid }
  end
  
  describe "with week blank" do
    before { @spread.week = "" }
    it { should_not be_valid }
  end
  
  describe "with year blank" do
    before { @spread.year = "" }
    it { should_not be_valid }
  end
  
  describe "with invalid favored team id" do
    before { @spread.favored_team_id = 33 }
    it { should_not be_valid }
  end
  
  describe "with invalid under team id" do
    before { @spread.under_team_id = 33 }
    it { should_not be_valid }
  end
  
end
