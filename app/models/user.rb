class User < ApplicationRecord
  self.table_name = 'users'
  self.primary_key = 'index'
  self.record_timestamps = false

  has_many :lists,
           class_name: 'List',
           foreign_key: 'owner'

  has_many :permissions,
           foreign_key: 'user_id'

  has_many :sessions,
           class_name: 'Session',
           foreign_key: 'account'
end
