class TanSession < ActiveRecord::Base
  belongs_to :bed
  belongs_to :customer
  belongs_to :salon
end
