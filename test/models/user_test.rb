require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: "testuser@example.com",
                     password: "foobar",
                     password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should accept valid email addresses" do
    valid_emails = %w[correct@example.com EXAMPLE@EXAMPLE.ORG co-r3ct@val1d.net]
    password, password_confirmation = "foobar"
    valid_emails.each do |email|
      @valid_user = User.create(email: email, password: password, password_confirmation: password_confirmation)
      assert @valid_user.valid?, "#{email.inspect} should be valid"
    end
  end

  test "should reject invalid email addresses" do
    invalid_emails = %w[wrong.com invalid_at_email. invalidwrong,com bad@]
    password, password_confirmation = "foobar"
    invalid_emails.each do |email|
      @invalid_user = User.create(email: email, password: password, password_confirmation: password_confirmation)
      assert_not @invalid_user.valid?, "#{email.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be a minimum length of 6 characters" do
    @user.password = "a"*5
    assert_not @user.valid?
  end

  test "password should match password_confirmation" do
    @user.password_confirmation = "foobra"
    assert_not @user.valid?
  end

  test "should create empty profile after creation" do
    assert @user.profile.first_name.blank?
  end

  test "dependents should be destroyed with the user" do
    @user.posts.create!(content: "lorem ipsum")
    assert_difference 'Post.count', -1 do
      @user.destroy
    end
  end
end
