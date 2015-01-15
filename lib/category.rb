require 'active_record'

class Category < ActiveRecord::Base
  has_many :contacts
end
