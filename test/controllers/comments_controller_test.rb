require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example1)
    @user_post = posts(:post1)
    @another_user = users(:example2)
    @another_users_post = posts(:post2)
    @another_users_comment = comments(:comment2)
    @friend_of_user = users(:example3)
    @friend_of_users_post = posts(:post3)
  end

  test "should redirect create unless signed in" do
    post comments_path
    assert_redirected_to user_session_path
  end

  test "should be able to create a comment on own post" do
    sign_in @user
    assert_difference 'Comment.count' do
      post comments_path, params: {comment: {content: "lorem ipsum", post_id: @user_post.id }}
    end
  end

  test "should redirect if content of comment blank" do
    sign_in @user
    post comments_path, params: {comment: {content: "", post_id: @user_post.id }}
    assert_redirected_to posts_path
  end

  test "should redirect if no post referenced" do
    sign_in @user
    post comments_path, params: {comment: {content: "lorem ipsum", post: nil }}
    assert_redirected_to posts_path
  end

  test "should redirect when destroying another user's comment" do
    sign_in @user
    assert_no_difference 'Comment.count' do
      delete comment_path(@another_users_comment.id)
    end
  end

  test "should not be able to comment on post if not friends" do
    sign_in @user
    assert_no_difference 'Comment.count' do
      post comments_path, params: {comment: {content: "lorem ipsum", post_id: @another_users_post.id }}
    end
    assert_redirected_to posts_path
  end

  test "should be able to comment on post of a friend" do
    sign_in @user
    assert_difference 'Comment.count' do
      post comments_path, params: {comment: {content: "nice latin", post_id: @friend_of_users_post.id }}
    end
  end
end
