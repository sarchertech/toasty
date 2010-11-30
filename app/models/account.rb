class Account < ActiveRecord::Base
  has_many :customers
  has_many :salons
  has_many :users
end
