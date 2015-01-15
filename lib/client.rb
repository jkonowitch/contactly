require 'active_record'
require 'securerandom'

class Client < ActiveRecord::Base
  has_many :categories
  has_many :contacts

  before_create :assign_key

  private

  def assign_key
    self.key = SecureRandom.hex
  end
end
