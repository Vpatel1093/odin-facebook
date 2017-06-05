require 'test_helper'

class UsersSignUpTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example1)
  end

  # Invalid sign up
  test "should not be able to sign up with invalid credentials" do
    get new_user_registration_path
    assert_no_difference 'User.count' do
      post '/users', params: { user: { email: " ",
                                       password: "fooblar",
                                       password_confirmation: "foobar" } }
    end
    assert_template 'devise/registrations/new'
  end

  # Valid sign up
  test "should be able to sign up and receive welcome email" do
    get new_user_registration_path
    assert_difference 'User.count' do
      post '/users', params: { user: { email: "integration@test.com",
                                       password: "foobar",
                                       password_confirmation: "foobar" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    follow_redirect!
    assert_template 'posts/index'
  end
end
