class CreateGossips < ActiveRecord::Migration[5.2]
  def change
    create_table :gossips do |t|
      t.string :title
      t.text :content
      t.timestamp :date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
