class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :likes, as: :likeable
  default_scope -> { order(created_at: :desc) }
  validates_presence_of :user, :content
end
