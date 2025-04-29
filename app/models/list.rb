class List < ApplicationRecord
  self.table_name = 'lists'
  self.primary_key = 'id'
  self.record_timestamps = false

  belongs_to :owner,
             class_name: 'User',
             foreign_key: 'owner'
  
  has_many :contentlists,
           class_name: 'Contentlist',
           foreign_key: 'listnumber'

  has_many :permissions,
           foreign_key: 'list_id'
end
