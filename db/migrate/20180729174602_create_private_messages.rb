class CreatePrivateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :private_messages do |t|
      t.text :content
      t.timestamp :date
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :receiver2_id
      t.integer :receiver3_id

      t.timestamps
    end
  end
end
