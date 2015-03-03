class PostsController < ApplicationController

  before_action :authorize_friend_post,           only: [:create]
  before_action :authorize_self_creator_receiver, only: [:destroy]

  def create
    content = params[:post][:content]
    unless content.blank?
      @post = current_user.created_posts.create(content: content,
                                        receiver_id: params[:receiver_id])
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end


  private


  def authorize_friend_post
    user = User.find(params[:receiver_id])
    msg  = "You can only create a post for yourself or your friends."
    authorize_user!(user, :friend, msg)
  end

  def authorize_self_creator_receiver
    post     = Post.find(params[:id])
    creator  = post.creator
    receiver = post.receiver
    msg      = "You can only delete posts you created or received."

    authorize_either_user!(creator, receiver, :self, msg)
  end
end
