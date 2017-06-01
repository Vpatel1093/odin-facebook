require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "testuser@example.com",
                         password: "foobar",
                         password_confirmation: "foobar")
    @post = @user.posts.create(content: "lorem ipsum")
    @comment = @post.comments.create(user: @user, content: "comment")
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "should have content" do
    @comment.content = ""
    assert_not @comment.valid?
  end

  test "should have a user_id" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "should have a post id" do
    @comment.post_id = nil
    assert_not @comment.valid?
  end

  test "dependent likes should be destroyed with the comment" do
    @comment.likes.create!(user: @user)
    assert_difference 'Like.count', -1 do
      @comment.destroy
    end
  end
end
