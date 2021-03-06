class FriendRequestsController < ApplicationController
  def index
    @friend_requests = current_user.received_friend_requests
  end

  def create
    @friend_request = current_user.friend_requests.build(friend_id: params[:friend_id])
    if @friend_request.save
      flash[:notice] = "Friend requested."
      redirect_to users_url
    else
      flash[:error] = "Unable to request friendship."
      redirect_to users_url
    end
  end

  def update
    @friend_request = FriendRequest.find_by(id: params[:id])
    @friend_request.update(accepted: true)
    if @friend_request.save
      flash[:notice] = "Friend request accepted."
      redirect_to root_url
    else
      flash[:error] = "Unable to confirm friend."
      redirect_to root_url
    end
  end

  def destroy
    @friend_request = FriendRequest.find_by(id: params[:id])
    @friend_request.destroy
    flash[:notice] = "Friend request denied."
    redirect_to root_url
  end
end
