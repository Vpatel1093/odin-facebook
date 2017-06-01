class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :likes, as: :likeable

  validates_presence_of :user_id, :post, :content
end
