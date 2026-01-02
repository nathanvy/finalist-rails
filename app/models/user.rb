class User < ApplicationRecord
  has_secure_password

  has_many :owned_lists, class_name: "List", foreign_key: :owner_id, dependent: :destroy
  has_many :list_memberships, dependent: :destroy
  has_many :lists, through: :list_memberships
  
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  def disabled?
    disabled_at.present?
  end
end
