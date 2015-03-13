module LikesHelper
  def find_like(likeable_id, likeable_type)
    Like.find_by(likeable_id: likeable_id, likeable_type: likeable_type,
                 user_id: current_user.id)
  end

  def get_like_info like
    { dom_id: like_dom_id(like), likers_dom_id: likers_dom_id(like),
      likeable_id: like.likeable_id, likeable_type: like.likeable_type }
  end

  def like_dom_id like
    "#{like.likeable_type.downcase}-#{like.likeable_id}-like"
  end

  def likers_dom_id like
    "#{like.likeable_type.downcase}-#{like.likeable_id}-likers"
  end

  def like_data(like, options={})
    like ? like_data_from_like(like) : like_data_from_options(options)
  end

  def like_data_from_like like
    { dom_id:        like_dom_id(like),
      likers_dom_id: likers_dom_id(like),
      likeable_id:   like.likeable_id,
      likeable_type: like.likeable_type,
      liked:         like.likeable }
  end

  def like_data_from_options options
    liked = case options[:likeable_type].downcase
            when "post"    then Post.find(options[:likeable_id])
            when "comment" then Comment.find(options[:likeable_id])
            end
    { dom_id:        options[:dom_id],
      likers_dom_id: options[:likers_dom_id],
      likeable_id:   options[:likeable_id],
      likeable_type: options[:likeable_type],
      liked:         liked }
  end
end
