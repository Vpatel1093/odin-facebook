require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example1)
    @user_post
    @friend_of_user = users(:example3)
    @friend_of_user_post = posts(:post3)
    @not_friend_of_user_post = posts(:post2)
  end

  test "post interface" do
    sign_in @user
    get posts_path
    assert_select 'h1', text: 'Timeline'
    assert_select 'a[href=?]', post_likes_path(@friend_of_user_post)
    assert_select 'a[href=?]', post_likes_path(@not_friend_of_user_post), count: 0
    assert_select 'a', text: 'Delete'
    # Invlid post creation
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: '' } }
    end
    assert_not flash.empty?
    # Valid post creation
    assert_difference 'Post.count' do
      post posts_path, params: { post: { content: 'I just joined odin-facebook!' } }
    end
    assert_redirected_to posts_path
    follow_redirect!
    assert_response :success

    # Invalid comment (can't comment if not friends)
    assert_no_difference 'Comment.count' do
      post comments_path, params: { comment: { post_id: @not_friend_of_user_post.id, content: "Nice post." } }
    end
    assert_redirected_to posts_path
    # Valid comment
    assert_difference 'Comment.count' do
      post comments_path, params: { comment: { post_id: @friend_of_user_post.id, content: "Welcome!" } }
    end
    assert_redirected_to posts_path
    follow_redirect!
    assert_response :success

    # Invalid like
    assert_no_difference 'Like.count' do
      post post_likes_path(@not_friend_of_user_post)
    end
    # Valid like
    assert_difference 'Like.count' do
      post post_likes_path(@friend_of_user_post)
    end
  end
end
