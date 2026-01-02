class Item < ApplicationRecord
  belongs_to :list

  scope :active, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }
  
  validates :body, presence: true
end
