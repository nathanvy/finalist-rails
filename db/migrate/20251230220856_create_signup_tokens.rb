class CreateSignupTokens < ActiveRecord::Migration[8.1]
  def change
    create_table :signup_tokens do |t|
      t.string :token_digest, null: false
      t.string :label
      t.datetime :expires_at
      t.integer :max_uses, null: false, default: 1
      t.integer :uses_count, null: false, default: 0
      t.datetime :revoked_at
      t.references :created_by_user, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :signup_tokens, :token_digest, unique: true
  end
end
