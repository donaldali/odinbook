class CommentsController < ApplicationController
  include CommentsHelper

  before_action :authorize_friend_post_creator_receiver, only: [:create]
  before_action :authorize_self_comment, only: [:destroy]

  def index
    @post_id  = params[:post_id]
    @comments = Post.find(@post_id).comments
    respond_to { |format| format.js } 
  end

  def create
    content  = params[:comment][:content]
    @comment = current_user.comments.create(content: content, 
                 post_id: params[:post_id]) unless content.blank?

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
    WebsocketRails[:updates].trigger(:add_comment, 
                             comment_info(@comment) ) unless @comment.nil?
  end

  def destroy
    @comment       = Comment.find(params[:id])
    comment_dom_id = comment_dom_id(@comment)
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
    WebsocketRails[:updates].trigger(:remove_comment, 
                                      comment_dom_id: comment_dom_id)
  end

  def add
    @comment = Comment.find(params[:id])
    render 'create'
  end


  private


  def authorize_self_comment
    user = Comment.find(params[:id]).commenter
    msg  = "You can only delete comments you created."
    authorize_user!(user, :self, msg)
  end

  def authorize_friend_post_creator_receiver
    post     = Post.find(params[:post_id])
    creator  = post.creator
    receiver = post.receiver
    msg      = "You can only comment on posts by or to you or your friends."

    authorize_either_user!(creator, receiver, :friend, msg)
  end

end
