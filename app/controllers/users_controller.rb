class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :update, :edit, :destroy]
  before_filter :correct_user, only: [:destroy, :update, :edit]
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @picks = @user.picks.order("created_at ASC")
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Success!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in(@user)
      redirect_to(@user)
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "Account Destroyed"
    redirect_to root_path
  end
  
  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless @user == current_user
    end
end
