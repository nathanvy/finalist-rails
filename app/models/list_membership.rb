class ListMembership < ApplicationRecord
  belongs_to :list
  belongs_to :user

  enum :role, { viewer: 0, editor: 1 }

  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :list_id }
end
