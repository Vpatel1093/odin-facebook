require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example1)
    @user_post = posts(:post1)
    @another_user = users(:example2)
    @another_users_post = posts(:post2)
  end

  test "should redirect create unless signed in" do
    post posts_path
    assert_redirected_to user_session_path
  end

  test "should be able to create a post if signed in" do
    sign_in @user
    post posts_path, params: {post: {content: "lorem ipsum" }}
  end

  test "should redirect if content of post blank" do
    sign_in @user
    post posts_path, params: {post: {content: "" }}
    assert_redirected_to posts_path
  end

  test "should redirect when deleting another user's post" do
    sign_in @user
    assert_no_difference 'Post.count' do
      delete post_path(@another_users_post.id)
    end
  end
end
