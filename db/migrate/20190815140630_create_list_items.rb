class CreateListItems < ActiveRecord::Migration[5.2]
  def change
    create_table :list_items do |t|
      t.string :name
      t.integer :list_id, foreign_key: true
      t.boolean :deleted, default: false, index: true
      t.timestamps
    end
  end
end
