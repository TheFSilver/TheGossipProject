class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.references :gossip, foreign_key: true
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps
    end
  end
end
