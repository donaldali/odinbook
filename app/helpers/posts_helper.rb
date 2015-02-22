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
      time_ago_in_words(datetime)
    end
  end
end
