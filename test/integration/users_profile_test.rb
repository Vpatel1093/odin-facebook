require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example1)
    @user_profile = profiles(:example1)
  end

  test "profile display and updating" do
    sign_in @user
    get edit_profile_path(@user_profile)
    assert_template 'profile/edit'
    assert_select 'h1', text: 'Edit profile'
    assert_match @user_profile.first_name, response.body
    assert_select 'nav'
    patch profile_path(@user_profile), params: { profile: { first_name: 'new', last_name: 'name' } }
    assert_redirected_to user_path(@user)
    follow_redirect!
    assert_template 'users/show'
    assert_match 'new name', response.body
  end
end
