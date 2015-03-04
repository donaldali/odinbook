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

def make_friends2(user, friend)
  click_on "All Users", match: :first
  within("#friend-status-#{friend.id}") do
    click_on "Add Friend"
  end
  click_on "Log Out", match: :first

  log_in(friend)
  click_on("Friend Requests")
  click_on("Confirm")
  click_on "Log Out", match: :first
  log_in(user)
end

def friend_request_to_from(user, friender)
  click_on "Log Out", match: :first

  log_in(friender)
  click_on "All Users", match: :first
  within("#friend-status-#{user.id}") do
    click_on "Add Friend"
  end
  click_on "Log Out", match: :first

  log_in(user)
end

def friend_request_from_to(user, friended)
  click_on "All Users", match: :first
  within("#friend-status-#{friended.id}") do
    click_on "Add Friend"
  end
end

def make_post_comment_likes(user, liker)
  click_on "Log Out", match: :first
  log_in(liker)

  visit timeline_path(liker)
  fill_in "Status", with: "Lorem post"
  click_button "Post"

  click_link "Like"

  within('.post-container') do 
    fill_in "Content", with: "Lorem comment"
    click_button "Comment"
  end

  click_link "Like"

  click_link "Log Out", match: :first
  log_in(user)
end

def make_user_private(user, private_user)
  click_on "Log Out", match: :first
  log_in(private_user)

  visit edit_profile_path(private_user.profile)
  choose "Friends"
  click_button "Update Profile"

  click_link "Log Out", match: :first
  log_in(user)  
end
