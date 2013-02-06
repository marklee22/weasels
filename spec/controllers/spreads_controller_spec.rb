require 'spec_helper'

describe SpreadsController do

  describe "GET index" do
    it "lists 16 spreads" do
      get :index
      assigns(:spreads).count.should == 16
    end
  end
end