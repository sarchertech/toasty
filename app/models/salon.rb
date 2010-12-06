class Salon < ActiveRecord::Base
  belongs_to :account
  has_many :beds
  has_many :customers
  has_many :users
  
  before_validation :san

  validates_presence_of :account_id, :zip_code, :time_zone, :address, :city,
                        :state, :identifier
  
  validates_length_of :zip_code, :is => 5, :message => "must be 5 digits long"  
  validates_length_of :identifier, :maximum => 12

  validates_numericality_of :zip_code

  validates_inclusion_of :time_zone, 
                     :in => ActiveSupport::TimeZone.us_zones.map { |z| z.name },
                     :message => "is not a valid US Time Zone"

  validates_uniqueness_of :identifier, :scope => :account_id

  validates_format_of :identifier, :without => /[^A-Za-z0-9_]/,
                      :message => "can only contain letters, numbers,
                                    and underscores"

  private

  def san
    self.identifier = identifier.strip.downcase if self.identifier
  end
end
