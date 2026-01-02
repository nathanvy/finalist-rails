class CreateLists < ActiveRecord::Migration[8.1]
  def change
    create_table :lists do |t|
      t.text :title, null: false
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
