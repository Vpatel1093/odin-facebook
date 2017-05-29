class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :friend_requests
  has_many :received_friend_requests, class_name: "FriendRequest", foreign_key: "friend_id", dependent: :destroy
  has_many :requested_friendships, -> { where(friend_requests: { accepted: false }) },
           through: :received_friend_requests, source: :user
  has_many :accepted_friends, -> { where(friend_requests: {accepted: true}) }, through: :friend_requests, source: :friend

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one :profile, dependent: :destroy

  after_create :build_empty_profile
  after_create :send_welcome_email

  def timeline
    Post.where("user_id IN (?) OR user_id = ?", accepted_friend_ids, id)
  end

  def full_name
    unless profile.first_name.blank? || profile.last_name.blank?
      return "#{profile.first_name} #{profile.last_name}"
    end
    email
  end

  def friends_with?(different_user)
    accepted_friends.include?(self)
  end

  def pending_friends?(different_user)
    requested_friendships.include?(different_user)
  end

  private

    def build_empty_profile
      Profile.create!(user: self)
    end

    def send_welcome_email
      UserMailer.welcome_email(self).deliver
    end
end
