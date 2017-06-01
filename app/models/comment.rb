class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy

  validates_presence_of :user_id, :post_id, :content
end
