require 'spec_helper'

describe NflTeam do
  before { @team = NflTeam.new(location: "San Francisco", name: "49ers", abbr: "SF") }
  subject { @team }
  
  it { should respond_to(:location) }
  it { should respond_to(:name) }
  it { should respond_to(:abbr) }
  it { should be_valid }
  
  describe "with blank location" do
    before { @team.location = "" }
    it { should_not be_valid }
  end
  
  describe "with blank name" do
    before { @team.name = "" }
    it { should_not be_valid }
  end
  
  describe "with blank abbr" do
    before { @team.name = "" }
    it { should_not be_valid }
  end
  
  describe "with same abbr" do
    before do
      team2 = @team.dup
      team2.save
    end
    it { should_not be_valid }
  end
end
