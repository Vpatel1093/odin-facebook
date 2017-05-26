class UserMailer < ApplicationMailer
  default from: 'noreply@example.com'

  def welcome_email(user)
    @user = user
    mail(to: email_with_name(user), subject: "Welcome to odin-facebook!")
  end

  private

    def email_with_name(user)
      "#{user.full_name} #{user.email}"
    end
end
