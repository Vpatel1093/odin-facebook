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

  has_one :prolfile, dependent: :destroy

  after_create :build_empty_profile

  def timeline
    Post.where("user_id IN (?) OR user_id = ?", accepted_friends_ids, id)
  end

  private

    def build_empty_profile
      Profile.create!(user: self)
    end
end
