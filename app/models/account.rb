class Account < ActiveRecord::Base
  include ApplicationExtensions

  has_many :customers
  has_many :salons
  has_many :users

  before_validation :strip_whitespace, :create_sub_domain

  private
  
  def strip_whitespace
    self.name = name.strip
  end

  def create_sub_domain
    self.sub_domain = url_sanitize(name)
  end
end
