require 'csv'

class SpreadsController < ApplicationController
  before_filter :signed_in_user
  
  def new
  end  
  
  def index
    @nfl_week ||= NFL_WEEK
    @nfl_year ||= NFL_YEAR
    if(params[:spread])
      @nfl_week = params[:spread][:week]
      @nfl_year = params[:spread][:year]
    end
    @weeks = Spread.where(:year => @nfl_year).order('week desc').uniq.pluck(:week)
    @years = Spread.order('year desc').uniq.pluck(:year)
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
      redirect_to spreads_path
    else
      flash[:error] = "Missing fields"
      render 'new'
    end
  end
end
