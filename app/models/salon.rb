class Salon < ActiveRecord::Base
  belongs_to :account
  has_many :beds
  has_many :customers
  has_many :users
end
