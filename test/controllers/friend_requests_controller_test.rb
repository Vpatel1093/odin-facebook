require 'test_helper'

class FriendRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example1)
    @friendship = friend_requests(:one)
    @another_user = users(:example2)
    @pending_friend_request = friend_requests(:two)
  end

  test "should get redirect if not signed in" do
    get friend_requests_url
    assert_redirected_to new_user_session_path
  end

  test "should get create" do
    sign_in @user
    post friend_requests_url(@another_user)
    assert_redirected_to users_url
  end

  test "should get update" do
    sign_in @user
    patch friend_request_url(@pending_friend_request)
    assert_redirected_to root_url
  end

  test "should get destroy" do
    sign_in @user
    delete friend_request_url(@pending_friend_request)
    assert_redirected_to root_url
  end
end
