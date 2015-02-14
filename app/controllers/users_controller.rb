class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @title = "All Users"
  end

  def newsfeed
  end
end
