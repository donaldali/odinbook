class PostsController < ApplicationController
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

end
