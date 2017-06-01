class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates_presence_of :user_id, :content
end
