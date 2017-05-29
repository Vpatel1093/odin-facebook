class PostsController < ApplicationController
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
    @post.destory
    flash[:notice] = "Post deleted."
    redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
