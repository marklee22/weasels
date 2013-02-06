require 'csv'

class SpreadsController < ApplicationController
  def new
  end  
  
  def index
    @nfl_week ||= NFL_WEEK
    @nfl_year ||= NFL_YEAR
    # week ||= NFL_WEEK
    # year ||= NFL_YEAR
    @weeks = Spread.where(:year => @nfl_year).order('week desc').uniq.pluck(:week)
    @years = Spread.order('year desc').uniq.pluck(:year)
    if(params[:spread])
      @nfl_week = params[:spread][:week]
      @nfl_year = params[:spread][:year]
    end
    @spreads = Spread.where("year = ? AND week = ?", @nfl_year, @nfl_week)
  end
    
  def upload
    if(request.post? && params[:csv_file].present? && params[:nfl_year] && params[:nfl_week])
      @spreads = []
      @nfl_week = params[:nfl_week]
      @nfl_year = params[:nfl_year]
      Spread.delete_all("week = #{@nfl_week} and year = #{@nfl_year}")
      CSV.parse(params[:csv_file].tempfile, { :col_sep => "\t", :headers => true } ) do |row|
        spread = Spread.build_from_csv(row, @nfl_week, @nfl_year)
        if(spread.valid?)
          spread.save
        else
          flash[:error] = spread.errors
        end
        @spreads.push(spread)
      end
      render 'edit'
    else
      flash[:error] = "Missing fields"
      render 'new'
    end
  end
end
