class Account < ActiveRecord::Base
  include ApplicationExtensions

  has_many :customers
  has_many :salons
  has_many :users

  before_validation :strip_whitespace, :create_sub_domain

  validates_inclusion_of :customer_location_access, :in => [true, false]
  validates_inclusion_of :user_location_access, :in => [true, false]

  validates_presence_of :account_number, :name
  
  validates_format_of :name, :without => /[^a-zA-Z0-9 ]/, 
                      :message => "must contain only letters, numbers,
                                   and spaces"

  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :sub_domain, :case_sensitive => false,
                          :message => "is already taken (your account name is
                                       not unique - please change it)"

  private
  
  def strip_whitespace
    self.name = name.strip.gsub(/ {2,}/,' ') if self.name
  end

  def create_sub_domain
    self.sub_domain = url_sanitize(name) if self.name
  end
end
