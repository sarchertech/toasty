class Bed < ActiveRecord::Base
  belongs_to :salon
  has_many :tan_sessions
  has_many :customers, :through => :tan_sessions
end
