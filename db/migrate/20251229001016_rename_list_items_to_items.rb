class RenameListItemsToItems < ActiveRecord::Migration[8.1]
  def change
    rename_table :list_items, :items
  end
end
