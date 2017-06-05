class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :friend_requests
  has_many :received_friend_requests, class_name: "FriendRequest", foreign_key: "friend_id", dependent: :destroy

  has_many :added_friends, -> { where(friend_requests: {accepted: true}) }, through: :friend_requests, source: :friend
  has_many :received_friends, -> { where(friend_requests: {accepted: true}) }, through: :received_friend_requests, source: :user

  has_many :requested_friends, -> { where(friend_requests: { accepted: false }) },
           through: :received_friend_requests, source: :user
  has_many :pending_friends,   -> { where(friend_requests: { accepted: false }) },
           through: :friend_requests, source: :friend

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_one :profile, dependent: :destroy

  after_create :build_empty_profile
  after_create :send_welcome_email

  def timeline
    Post.where("user_id IN (?) OR user_id = ?", added_friend_ids, id) | Post.where("user_id IN (?) OR user_id = ?", received_friend_ids, id)
  end

  def full_name
    unless profile.first_name.blank? || profile.last_name.blank?
      return "#{profile.first_name} #{profile.last_name}"
    end
    email
  end

  def friends_with?(different_user)
    (added_friends | received_friends).include?(self)
  end

  def pending_friends?(different_user)
    (requested_friends | pending_friends).include?(different_user)
  end

  def has_liked_this?(likeable)
    likeable.likes.where(user_id: id).blank? ? false : true
  end

  def self.from_omniauth(auth)
    where(provider: auth_provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  private

    def build_empty_profile
      Profile.create!(user: self)
    end

    def send_welcome_email
      UserMailer.welcome_email(self).deliver
    end
end
