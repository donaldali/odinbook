module LikesHelper
  def find_like(likeable_id, likeable_type)
    Like.find_by(likeable_id: likeable_id, likeable_type: likeable_type,
                 user_id: current_user.id)
  end
end
