def sign_in(user)
  visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign In"

#  post sessions_path, :email => 'MarkLee805@gmail.com', :password => 'password', :password_confirmation => 'password'
end