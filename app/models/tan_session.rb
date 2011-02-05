class TanSession < ActiveRecord::Base
  belongs_to :bed
  belongs_to :customer
  belongs_to :salon

  validates_presence_of :bed_id, :customer_id, :salon_id, :minutes

  validates_inclusion_of :minutes, :in => 2..20

  default_scope :order => 'created_at DESC'
end
