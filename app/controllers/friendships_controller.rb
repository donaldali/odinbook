class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:friended_id])
    current_user.send_friend_request_to(user)
    redirect_to users_path
  end

  def update
    user = Friendship.find(params[:id]).friender
    current_user.accept_friend_request_from(user)
    redirect_to users_path
  end

  def destroy
    Friendship.find(params[:id]).destroy
    redirect_to users_path
  end
end
