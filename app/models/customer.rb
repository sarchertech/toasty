class Customer < ActiveRecord::Base
  belongs_to :account
  belongs_to :salon
  has_many :tan_sessions  
  has_many :beds, :through => :tan_sessions

  before_validation :san

  validates_presence_of :last_name, :first_name, :customer_number, :level,
                        :phone_number

  validates_numericality_of :phone_number

  validates_length_of :last_name, :first_name, :maximum => 40
  validates_length_of :phone_number, :is => 10, 
                      :message => "must be 10 digits long"

  validates_format_of :last_name, :first_name, :without => /[^A-Za-z -]/,
                      :message => "can only contain letters, spaces, and hypens"
  validates_format_of :email, :with => /^.+@.+\..+$/, :allow_nil => true,
                      :message => "not a valid email"

  validates_inclusion_of :level, :in => 1..6

  private

  def san
    self.first_name = first_name.strip if self.first_name
    self.last_name = last_name.strip if self.last_name
    self.customer_number = customer_number.strip if self.customer_number
    self.email = email.strip if self.email
    self.phone_number = phone_number.gsub(/[.-]/, "") if self.phone_number
  end
end
