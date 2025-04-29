class Contentlist < ApplicationRecord
  self.table_name = 'contentlist'
  self.primary_key = 'index'
  self.record_timestamps = false

  belongs_to :list,
             class_name: "List",
             foreign_key: 'listnumber'

end
