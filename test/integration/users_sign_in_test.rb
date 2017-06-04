require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example1)
  end

  test "sign in with valid information followed by logout" do
    get new_user_session_path
    post new_user_session_path, params: { 'user[email]': @user.email, 'user[password]': "foobar" }
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'posts/index'
    assert_select "a[href=?]", new_user_session_path, count:0
    assert_select "a[href=?]", destroy_user_session_path
    assert_select "a[href=?]", user_path(@user)
    delete destroy_user_session_path
    assert_redirected_to new_user_session_path
    # Simulate a user clicking signout in second window
    delete destroy_user_session_path
    follow_redirect!
    assert_select "a[href=?]", new_user_session_path
    assert_select "a[href=?]", destroy_user_session_path, count:0
    assert_select "a[href=?]", user_path(@user), count:0
  end

  test "sign in with invalid information" do
    get new_user_session_path
    assert_template 'devise/sessions/new'
    post new_user_session_path, params: { 'user[email]': @user.email, 'user[password]': "fooblar" }
    assert_template 'devise/sessions/new'
    assert_not flash.empty?
    get root_path
    assert_not flash.empty?
  end
end
