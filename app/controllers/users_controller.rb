class UsersController < ApplicationController
  include UsersHelper

  def newsfeed
    @receiver_id = params[:id]
    @label       = "Update Status"
    @placeholder = "What's on your mind?"
    @posts       = Post.all.order(created_at: :desc)
  end

  def timeline
    @receiver_id = params[:id]
    @label       = get_status(@receiver_id)
    @placeholder = get_placeholder(@receiver_id)
    @posts       = Post.all.order(created_at: :desc).limit(1)
    render layout: "profiles"
  end

  def index
    @users    = User.all.alphabetize
    @title    = "All Users"
    @is_index = true
  end

  def friends
    @receiver_id = params[:id]
    @users       = User.find(@receiver_id).friends
    @title       = "Friends"
    @is_index    = false
    if params[:from] == "profile"
      render template: "profiles/friends", layout: "layouts/profiles"
    else
      render "index"
    end
  end

  def friend_requests
    @users    = current_user.requests_from
    @title    = "Friend Requests"
    @is_index = false
    render "index"
  end

  def find_friends
    @users    = current_user.no_friendship - [current_user]
    @title    = "Find Friends"
    @is_index = false
    render "index"
  end
end
