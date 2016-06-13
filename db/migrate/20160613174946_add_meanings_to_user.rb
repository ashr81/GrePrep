class AddMeaningsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :meanings, :text, array: true, default: []
  end
end
