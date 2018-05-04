class CreatePolls < ActiveRecord::Migration[5.1]
  def change
    create_table :polls do |t|
      t.string :title, null: false
      t.integer :user_id, null:false
    end
    add_index :polls, :user_id
    add_index :polls, [:title, :user_id], unique: true
  end
end
