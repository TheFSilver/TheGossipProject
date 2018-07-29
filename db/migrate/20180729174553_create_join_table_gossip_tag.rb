class CreateJoinTableGossipTag < ActiveRecord::Migration[5.2]
  def change
    create_join_table :gossips, :tags do |t|
      # t.index [:gossip_id, :tag_id]
      # t.index [:tag_id, :gossip_id]
    end
  end
end
