class AddColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :polls, :created_at, :datetime, null: false
    add_column :polls, :updated_at, :datetime, null: false
  end
end
