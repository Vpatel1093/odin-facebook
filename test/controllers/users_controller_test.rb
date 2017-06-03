require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example1)
    @another_user = users(:example2)
  end

  test "should be able to sign in" do
    get new_user_session_url
    sign_in @user
  end

  test "should redirect to login if not logged in" do
    get users_path
    assert_redirected_to new_user_session_url
  end

  test "should be able to access home page when signed in" do
    sign_in @user
    get users_path
    assert_response :success
  end

  test "should not be able to destroy user if not signed in" do
    assert_no_difference 'User.count' do
      delete users_path(@user)
    end
  end

  test "should have access to own timeline" do
    sign_in @user
    get user_path(@user)
  end
end
