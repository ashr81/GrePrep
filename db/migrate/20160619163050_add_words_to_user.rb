class AddWordsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :words, :text, array: true, default: []
  end
end
