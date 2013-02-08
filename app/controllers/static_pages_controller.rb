class StaticPagesController < ApplicationController
  def home
    if(signed_in?)
      @picks = current_user.picks
      @picks.each do |pick|
        logger.debug("PICK: #{pick.spread}")
      end
    end
  end
  
  def about
  end
  
  def contact
  end
  
  def rules
  end

end
