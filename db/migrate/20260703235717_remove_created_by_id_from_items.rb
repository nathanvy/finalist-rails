class RemoveCreatedByIdFromItems < ActiveRecord::Migration[8.1]
  def change
    remove_reference :items, :created_by, foreign_key: { to_table: :users }, index: true
  end
end
