require 'spec_helper'

describe Pick do
  before { @pick = Pick.new(bye: false, pick_team_id: 1, spread_id: 1, user_id: 1, wildcard: 0) }
  
  subject { @pick }
  
  it { should respond_to(:bye) }
  it { should respond_to(:pick_team_id) }
  it { should respond_to(:spread_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:wildcard) }
  it { should be_valid }
  
  describe "with blank pick_team_id" do
    before { @pick.pick_team_id = "" }
    it { should_not be_valid }
  end
  
  describe "with blank spread_id" do
    before { @pick.spread_id = "" }
    it { should_not be_valid }
  end
  
  describe "with blank user_id" do
    before { @pick.user_id = "" }
    it { should_not be_valid }
  end
  
  describe "with invalid wildcard number" do
    before { @pick.wildcard = 10 }
    it { should_not be_valid }
  end
  
  pending "with default values" do
  end

end
