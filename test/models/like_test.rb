require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "testuser@example.com",
                         password: "foobar",
                         password_confirmation: "foobar")
    @post = @user.posts.create(content: "lorem ipsum")
    @comment = @post.comments.create(user: @user, content: "comment")
    @like = @comment.likes.create(user: @user)
  end

  test "should be valid" do
    assert @like.valid?
  end

  test "should have user id" do
    @like.user_id = nil
    assert_not @like.valid?
  end

  test "should only be able to like posts and comments" do
    user_like = @user.likes.create(user: @user)
    assert_not user_like.valid?
  end

  test "users should have unique likes" do
    second_like_on_same_comment = @comment.likes.create(user: @user)
    assert_not second_like_on_same_comment.valid?
  end
end
