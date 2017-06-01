require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "testuser@example.com",
                         password: "foobar",
                         password_confirmation: "foobar")
    @post = @user.posts.create(content: "lorem ipsum")
  end

  test "should be valid" do
    post = @user.posts.build(content: "lorem ipsum")
    assert post.valid?
  end

  test "should have content" do
    @post.content = ""
    assert_not @post.valid?
  end

  test "should have a user id" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test "order should be most recent first" do
    post2 = @user.posts.create(content: "most recent post")
    assert_equal post2, Post.first
  end

  test "dependent comments should be destroyed with the post" do
    @post.comments.create!(user: @user, content: "lorem ipsum")
    assert_difference 'Comment.count', -1 do
      @post.destroy
    end
  end

  test "dependent likes should be destroyed with the post" do
    @post.likes.create!(user: @user)
    assert_difference 'Like.count', -1 do
      @post.destroy
    end
  end
end
