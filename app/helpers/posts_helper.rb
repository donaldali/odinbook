module PostsHelper
  def post_likers(post, likes)
    you_liked = !find_like(post.id, "Post").nil?

    if likes == 1
      you_liked ? "You like this" : "1 person likes this"
    else
      you_liked ? "You and #{pluralize(likes - 1, 'other')} like this"
                : "#{likes} people like this"
    end
  end

  def format_datetime(datetime)
    if (Time.now - datetime) >= 1.day
      datetime.strftime("%B %-d, %Y at %l:%M%P")
    else
      time_ago_in_words(datetime).gsub("hour", "hr").gsub("minute", "min")
    end
  end

  # After it is determined that a user is on a Newsfeed or Timeline
  # feed, determine if that feed should get the new post
  def validate_post_for_user_location(post, user, action)
    # First verify that the person on a Newsfeed is the current user, or
    # if the current user is on a user's Timeline, the current user
    # is allowed to see posts on that Timeline (depending on the user's
    # privacy setting)
    unless (( action == 'newsfeed' && access_level?(user, :self) ) ||
            ( action == 'timeline' && access_level?(user, :public) ))
      return false
    end

    receiver = post.receiver
    creator  = post.creator
    # Now check if the Newsfeed or Timeline of the user should receive
    # the new post.  Newsfeeds get posts created for or by the owner,
    # or friends of the owner, of the Newsfeed; Timelines only get
    # posts created for or by the owner of the Timeline.
    ( action == 'newsfeed' && (access_level?(receiver, :friend) || 
                               access_level?(creator,  :friend)) ) ||
    ( action == 'timeline' && (receiver == user || creator == user) )
  end

  def post_dom_id post
    "post-#{ post.id }"
  end
end
