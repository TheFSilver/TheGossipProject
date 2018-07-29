class Like < ApplicationRecord
  belongs_to :user
  belongs_to :gossip, optional: true
  belongs_to :comment, optional: true
end
