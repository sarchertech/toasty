class Account < ActiveRecord::Base
  include ApplicationExtensions

  has_many :customers
  has_many :salons
  has_many :users

  before_validation :strip_whitespace, :create_sub_domain

  validates_inclusion_of :customer_location_access, :in => [true, false]
  validates_inclusion_of :user_location_access, :in => [true, false]

  validates_presence_of :account_number
  
  validates_format_of :name, :without => /[^a-zA-Z0-9\s]/, 
                      :message => "must contain only letters, numbers,
                                   and spaces"

  private
  
  def strip_whitespace
    self.name = name.strip
  end

  def create_sub_domain
    self.sub_domain = url_sanitize(name)
  end
end
