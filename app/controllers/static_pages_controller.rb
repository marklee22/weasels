class StaticPagesController < ApplicationController
  def home
    if(signed_in?)
      @user = current_user
      @picks = current_user.picks
    end
  end
  
  def about
  end
  
  def contact
  end
  
  def rules
  end

end
