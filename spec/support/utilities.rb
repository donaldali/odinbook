include ApplicationHelper

def log_in(user)
  visit new_user_session_path
  within("#login-form") do
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
  end
  click_on "Log In"
end

def sign_up(user)
  visit new_user_registration_path
  within("#signup-form") do 
    fill_in "First name", with: user.first_name
    fill_in "Last name",  with: user.last_name
    fill_in "Email",      with: user.email
    fill_in "Password",   with: user.password
    fill_in "Password confirmation", with: user.password
  end
  click_on "Sign Up"
end

def make_friends(user1, user2)
  user1.send_friend_request_to(user2)
  user2.accept_friend_request_from(user1)
end
