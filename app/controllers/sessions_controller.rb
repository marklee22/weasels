class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = authenticate(params[:sessions][:email], params[:sessions][:password])
    if(user)
      flash[:success] = "You Successfully signed in"
      sign_in(user)
      redirect_to edit_user_path(user)
    else
      flash.now[:error] = "Invalid Username/Password"
      render 'new'
    end
  end
  
  def destroy
    sign_out
    flash[:notice] = "Signed Out"
    redirect_to root_path
  end
end
