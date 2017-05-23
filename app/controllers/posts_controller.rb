class PostsController < ApplicationController
  def index
    @posts = current_user.posts
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "Post created"
    else
      redirect_to posts_path, alert: "Error posting"
    end
  end

  private

  def post_params
    params.require(:post).permit(:post_id, :content)
  end
end
