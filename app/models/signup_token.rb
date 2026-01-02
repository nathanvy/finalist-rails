class SignupToken < ApplicationRecord
  belongs_to :created_by_user, class_name: "User"

  def usable?
    revoked_at.nil? &&
      (expires_at.nil? || expires_at > Time.current) &&
      uses_count < max_uses
  end
end
