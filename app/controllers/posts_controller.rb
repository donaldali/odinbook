class PostsController < ApplicationController
  include PostsHelper

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
    WebsocketRails[:updates].trigger(:add_post, 
      {id: @post.id}) unless @post.nil?
  end

  def destroy
    @post = Post.find(params[:id])
    post_dom_id = post_dom_id(@post)
    @post.destroy
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
    WebsocketRails[:updates].trigger(:remove_post, post_dom_id: post_dom_id)
  end

  def add
    @post     = Post.find(params[:id])
    user      = User.find(params[:post][:user_id])
    action    = params[:post][:action]
    @add_post = validate_post_for_user_location(@post, user, action)
    
    render 'add'
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
