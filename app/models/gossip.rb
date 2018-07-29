class Gossip < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :comments, as: :commentable
  has_many :likes
end
