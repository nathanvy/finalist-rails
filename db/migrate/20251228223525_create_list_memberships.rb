class CreateListMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :list_memberships do |t|
      t.references :list, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :role, null: false

      t.timestamps
    end

    add_index :list_memberships, [ :list_id, :user_id ], unique: true
  end
end
