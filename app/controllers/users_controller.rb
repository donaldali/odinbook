class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all.alphabetize
    @title = "All Users"
    @is_index = true
  end

  def newsfeed
    @receiver_id = params[:id]
    @label = "Update Status"
    @placeholder = "What's on your mind?"
    @posts = Post.all
  end

  def friends
    @users = current_user.friends
    @title = "Friends"
    @is_index = false
    render "index"
  end

  def friend_requests
    @users = current_user.requests_from
    @title = "Friend Requests"
    @is_index = false
    render "index"
  end

  def find_friends
    @users = current_user.no_friendship
    @title = "Find Friends"
    @is_index = false
    render "index"
  end
end
