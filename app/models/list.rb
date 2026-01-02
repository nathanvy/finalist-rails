class List < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :list_memberships, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :members, through: :list_memberships, source: :user

  validates :title, presence: true

  def viewable_by?(user)
    owner_id == user.id || list_memberships.exists?(user_id: user.id)
  end

  def editable_by?(user)
    return true if owner_id == user.id
    list_memberships.where(user_id: user.id).where(role: ListMembership.roles[:editor]).exists?
  end
end
