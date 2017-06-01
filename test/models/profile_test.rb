require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: "testuser@example.com",
                     password: "foobar",
                     password_confirmation: "foobar")
  end

  test "should exist after user creation" do
    assert @user.profile
  end

  test "first name and last name should be blank" do
    assert @user.profile.first_name.blank? && @user.profile.last_name.blank?
  end
end
