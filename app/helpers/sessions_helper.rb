module SessionsHelper
  def authenticate(username, password)
    user = User.find_by_email(username).try(:authenticate, password)
  end
  
  def current_user
    @current_user ||= User.find_by_remember_token(session[:remember_token])
  end
  
  def sign_in(user)
    @current_user = user
    session[:remember_token] = user.remember_token
  end
  
  def sign_out
    @current_user = nil
    session.delete :remember_token
  end
  
  def signed_in_user
    if(current_user.nil?)
      redirect_to signin_url, notice: "Please sign in"
    end
  end
end
