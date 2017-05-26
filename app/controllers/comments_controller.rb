class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)

    if @comment.save
      redirect_to posts_path, notice: "Successfully commented"
    else
      redirect_to posts_path, alert: "Error commenting"
    end
  end


  private

    def comment_params
      params.require(:comment).permit(:post_id, :content)
    end
end
