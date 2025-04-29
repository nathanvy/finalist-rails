class Session < ApplicationRecord
  self.table_name = 'sessions'
  self.primary_key = 'sid'
  self.record_timestamps = false

  belongs_to :user,
             foreign_key: 'account'
end
