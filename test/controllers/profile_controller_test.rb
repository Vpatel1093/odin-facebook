require 'test_helper'

class ProfileControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example1)
    @user_profile = profiles(:example1)
  end

  test "should get redirect if not signed in" do
    get edit_profile_url(@user_profile)
    assert_redirected_to new_user_session_url
  end

  test "should get edit" do
    sign_in @user
    get edit_profile_url(@user_profile)
    assert_response :success
  end

  test "should get update" do
    sign_in @user
    patch profile_url(@user_profile), params: { profile: { first_name: "example", last_name: "user" } }
    assert_redirected_to user_path(@user)
  end
end
