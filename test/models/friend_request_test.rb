require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: "testuser@example.com",
                     password: "foobar",
                     password_confirmation: "foobar")
    @user2 = User.create(email: "testuser2@example.com",
                     password: "foobar",
                     password_confirmation: "foobar")
    @friend_request = FriendRequest.create(user: @user, friend: @user2)
  end

  test "should be valid" do
    assert @friend_request.valid?
  end

  test "should not be accepted by default" do
    assert_equal @friend_request.accepted, false
  end
end
