require 'active_record'

class Contact < ActiveRecord::Base
  belongs_to :category
end
