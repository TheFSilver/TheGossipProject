class User < ApplicationRecord
  belongs_to :city
  has_many :sent_messages, :class_name => "Message", :foreign_key => "sender_id"
  has_many :received_messages, :class_name => "Message", :foreign_key => "receiver_id"
  has_many :received_messages, :class_name => "Message", :foreign_key => "receiver2_id"
  has_many :received_messages, :class_name => "Message", :foreign_key => "receiver3_id"
  has_many :gossips
  has_many :comments
end

