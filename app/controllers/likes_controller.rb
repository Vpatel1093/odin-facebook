class LikesController < ApplicationController
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
    redirect_to :back
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
end
