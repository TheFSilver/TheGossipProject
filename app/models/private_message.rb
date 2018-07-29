class PrivateMessage < ApplicationRecord
  belongs_to :sender, :class_name=>'User', :foreign_key=>'sender_id'
  belongs_to :receiver, :class_name=>'User', :foreign_key=>'receiver_id'
  belongs_to :receiver2, :class_name=>'User', :foreign_key=>'receiver2_id', optional: true
  belongs_to :receiver3, :class_name=>'User', :foreign_key=>'receiver3_id', optional: true
end
