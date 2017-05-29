class CommentsController < ApplicationController
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
    redirect_to :back
  end

  private

    def comment_params
      params.require(:comment).permit(:post_id, :content)
    end
end
