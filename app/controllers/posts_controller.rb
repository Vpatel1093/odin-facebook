class PostsController < ApplicationController
  before_action :correct_user?, only: :destroy

  def index
    @posts = current_user.timeline
    @post = current_user.posts.build
    @comment = current_user.comments.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created"
      redirect_to posts_path
    else
      flash[:alert] = "Error posting"
      redirect_to posts_path
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "Post deleted."
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def correct_user?
    post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
