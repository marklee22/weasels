class StaticPagesController < ApplicationController
  def home
  end
  
  def about
  end
  
  def contact
  end
  
  def help
  end
  
  def spreads
    @nfl_week = 16
    @nfl_year = 2012
    @spreads = Spread.where(week: @nfl_week, year: @nfl_year)
  end
  
end
