class PostsController < ApplicationController
  def create
    content = params[:post][:content]
    unless content.blank?
      current_user.created_posts.create(content: content,
                                        receiver_id: params[:receiver_id])
    end

    redirect_to :back
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to :back
  end

end
