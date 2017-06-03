class CommentsController < ApplicationController
  before_action :friend_of_poster?, only: :create
  before_action :owner_of_comment?, only: :destroy

  def create
    @comment = current_user.comments.build(comment_params)

    if @comment.save
      redirect_to posts_path, notice: "Commented!"
    else
      redirect_to posts_path, alert: "Error commenting"
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy
    flash[:notice] = "Comment deleted."
    redirect_to posts_path
  end

  private

    def comment_params
      params.require(:comment).permit(:post_id, :content)
    end

    def owner_of_comment?
      comment = current_user.comments.find_by(id: params[:id], post_id: params[:post_id])
      redirect_to posts_path if comment.nil?
    end

    def friend_of_poster?
      post = Post.find_by(id: params[:comment][:post_id])
      post_creator = User.find_by(id: post.user_id) if post
      friendships = FriendRequest.where(user_id: post_creator.id).where(friend_id: current_user.id).where(accepted: true) + FriendRequest.where(user_id: current_user.id).where(friend_id: post_creator.id).where(accepted: true) if post_creator
      not_friends = friendships.empty? if post_creator
      current_user_is_poster = current_user.id == post_creator.id if post_creator
      redirect_to posts_path if not_friends && !(current_user_is_poster)
    end
end
