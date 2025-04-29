class Permission < ApplicationRecord
  self.table_name = 'permissions'
  self.primary_key = 'id'
  self.record_timestamps = false

  belongs_to :list
  belongs_to :user
end
