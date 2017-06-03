class LikesController < ApplicationController
  before_action :friend_of_likeable_creator?, only: :create

  def create
    @likeable = find_likeable
    @like = current_user.likes.build(likeable: @likeable)

    if @like.save
      redirect_to posts_path, notice: "Liked!"
    else
      redirect_to posts_path, alert: "Error liking"
    end
  end

  def destroy
    @likeable = find_likeable
    @like = Like.find_by(likeable_id: @likeable.id, user_id: current_user.id)
    @like.destroy
    flash[:notice] = "Unliked."
    redirect_to posts_path
  end

  private

    def find_likeable
      params.each do |name,value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end

    def friend_of_likeable_creator?
      @likeable = find_likeable
      likeable_creator = User.find_by(id: @likeable.user_id) if @likeable
      friendships = FriendRequest.where(user_id: likeable_creator.id).where(friend_id: current_user.id).where(accepted: true) + FriendRequest.where(user_id: current_user.id).where(friend_id: likeable_creator.id).where(accepted: true) if likeable_creator
      not_friends = friendships.empty? if likeable_creator
      current_user_is_likeable_creator = current_user.id == likeable_creator.id if likeable_creator
      redirect_to posts_path if not_friends && !(current_user_is_likeable_creator)
    end
end
