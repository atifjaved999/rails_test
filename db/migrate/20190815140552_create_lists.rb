class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :name
      t.boolean :deleted, default: false, index: true
      t.timestamps
    end
  end
end
