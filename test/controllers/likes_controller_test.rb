require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example1)
    @user_post = posts(:post1)
    @user_like_of_own_post = likes(:like1)
    @another_users_post = posts(:post2)
    @another_users_comment = comments(:comment2)
    @friend_of_users_post = posts(:post3)
  end

  test "should redirect comment like unless signed in" do
    post comment_likes_path(@another_users_comment)
    assert_redirected_to new_user_session_path
  end

  test "should redirect post like unless signed in" do
    post post_likes_path(@another_users_post)
    assert_redirected_to new_user_session_path
  end

  test "should be able to like own post" do
    sign_in @user
    post post_likes_path(@user_post)
    assert :success
  end

  test "should not be able to like likeable of nonfriend" do
    sign_in @user
    assert_no_difference 'Like.count' do
      post comment_likes_path(@another_users_comment)
    end
    assert_redirected_to posts_path
  end

  test "should be able to like likeable of friend" do
    sign_in @user
    assert_difference 'Like.count' do
      post post_likes_path(@friend_of_users_post)
    end
  end

  test "should be able to unlike" do
    sign_in @user
    assert_difference 'Like.count', -1 do
      delete post_like_path(@user_post, @user_like_of_own_post)
    end
  end
end
