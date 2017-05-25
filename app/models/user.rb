class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :friend_requests
  has_many :received_friend_requests, class_name: "FriendRequest", foreign_key: "friend_id"
  has_many :requested_friendships, -> { where(friend_requests: { accepted: false }) },
           through: :received_friend_requests, source: :user

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
end
