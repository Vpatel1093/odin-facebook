require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example1)
    @pending_user = users(:example2)
    @friend_of_user = users(:example3)
    @another_user = users(:example4)
  end

  test "see other users and friend request status" do
    sign_in @user
    get users_path
    assert_template 'users/index'
    assert_select 'h1', text: 'Users'
    assert_match @another_user.full_name, response.body
    assert_select 'a[href=?]', friend_requests_path(friend_id: @another_user.id), text: 'Add friend'
    assert_match @friend_of_user.full_name, response.body
    assert_match 'Friends', response.body
    assert_match @pending_user.full_name, response.body
    assert_select 'Pending', response.body
  end
end
