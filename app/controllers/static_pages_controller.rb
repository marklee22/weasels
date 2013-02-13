class StaticPagesController < ApplicationController
  def home
    if(signed_in?)
      @user = current_user
      @picks = @user.picks.find(:all, include: [:spread], order: 'spreads.week desc', conditions: "spreads.year = #{NFL_YEAR}")
    end
  end
  
  def about
  end
  
  def contact
  end
  
  def rules
  end

end
