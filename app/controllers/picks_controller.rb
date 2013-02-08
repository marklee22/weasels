class PicksController < ApplicationController
  before_filter :signed_in_user, only: [:destroy, :create]
  before_filter :correct_user, only: :destroy
  
  def new
    if(params[:bye])
      # Do something
    else
      @pick = Pick.new(spread_id: params[:spread], wildcard: 0, bye: false)
    end
  end
  
  def create
    @pick = current_user.picks.build(params[:pick])
    logger.debug("TEAM - #{@pick.nflTeam.team_name}, #{@pick.user.email}")
    if @pick.save
      flash[:success] = "Pick submitted"
    else
      flash[:error] = @pick.errors.messages
    end
    redirect_to user_path(current_user.id)
  end

  def destroy
    Pick.find_by_id(params[:id]).destroy
    redirect_to root_url
  end
  
  def edit
    redirect_to 'users/show'
  end
  
  private
    def correct_user
      @pick = current_user.picks.find_by_id(params[:id])
      redirect_to root_url if @pick.nil?
    end
end
