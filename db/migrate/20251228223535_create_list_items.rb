class CreateListItems < ActiveRecord::Migration[8.1]
  def change
    create_table :list_items do |t|
      t.references :list, null: false, foreign_key: true
      t.text :body, null: false
      t.integer :position
      t.datetime :completed_at
      t.references :created_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
