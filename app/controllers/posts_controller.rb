class PostsController < ApplicationController
  def index
    @posts = current_user.posts
    @post = current_user.posts.build
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

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
