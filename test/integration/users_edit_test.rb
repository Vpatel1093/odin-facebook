require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:example1)
  end

  test "unsuccessful edit" do
    sign_in @user
    get edit_user_registration_path
    assert_template 'devise/registrations/edit'
    patch user_registration_path, params: { user: { email: 'changedemail@example.com',
                                                    password: 'foobar',
                                                    password_confirmation: 'fooblar',
                                                    current_password: '' } }
    assert_template 'devise/registrations/edit'
    @user.reload
    assert_not_equal 'changedemail@example.com', @user.email
  end

  test "successful edit" do
    sign_in @user
    get edit_user_registration_path
    assert_template 'devise/registrations/edit'
    patch user_registration_path, params: { user: { email: 'changedemail@example.com',
                                                    password: 'foobar',
                                                    password_confirmation: 'foobar',
                                                    current_password: 'foobar' } }
    follow_redirect!
    assert_template 'posts/index'
    @user.reload
    assert_equal 'changedemail@example.com', @user.email
  end
end
