module CommentsHelper
  def dom_parent_id comment 
    "post-#{ comment.post.id }-comments"
  end

  def comment_dom_id comment
    "comment-#{ comment.id }"
  end

  def comment_info comment
    { id: comment.id, dom_parent_id: dom_parent_id(comment) }
  end
end
