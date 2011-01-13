class Customer < ActiveRecord::Base
  belongs_to :account
  belongs_to :salon
  has_many :tan_sessions  
  has_many :beds, :through => :tan_sessions

  before_validation :san, :nilify

  validate :validate_paid_through, :if => :month_to_month?

  validates_presence_of :last_name, :first_name, :customer_number, :level,
                        :phone_number, :address, :city, :zip_code,
                        :state, :account_id, :salon_id

  validates_presence_of :paid_through, :if => :month_to_month?
  
  validates_numericality_of :phone_number, :zip_code

  validates_numericality_of :sessions_left, :greater_than => 0, :if => :package?

  validates_length_of :last_name, :first_name, :maximum => 40
  validates_length_of :phone_number, :is => 10, 
                      :message => "must be 10 digits long"
  validates_length_of :zip_code, :is => 5,
                      :message => "must be 5 digits long"

  validates_format_of :last_name, :first_name, :without => /[^A-Za-z-]/,
                      :message => "can only contain letters, & hypens, no spaces"
  validates_format_of :email, :with => /^.+@.+\..+$/, :allow_nil => true,
                      :message => "not a valid email"

  validates_inclusion_of :level, :in => 0..5

  #1 == recurring 2 == month to month 3 == by the package 4 == per session
  validates_inclusion_of :customer_type, :in => 1..4

  default_scope :order => 'created_at DESC'

  scope :filter, lambda { |name, level, type|
    by_name(name).by_level(level).by_type(type)
  }

  #add functionality for this later
  scope :by_tanned, lambda { |tanned|
    return if tanned.blank? || tanned[:days].blank? || tanned[:hhn].blank?
    
    if tanned[:hhn] == "have"     
      joins("LEFT JOIN tan_sessions ON customers.id = tan_sessions.customer_id").
      where("tan_sessions.created_at > ?", tanned[:days].to_i.days.ago ) 
    elsif tanned[:hhn] == "have_not"
      joins("LEFT JOIN tan_sessions ON customers.id = tan_sessions.customer_id").
      where("tan_sessions.created_at < ? OR tan_sessions.created_at IS NULL", 
            tanned[:days].to_i.days.ago) 
    end
  }

  scope :by_name, lambda { |name|
    return if name.blank?
    name = name.split(' ')
    str1 = "(first_name LIKE :first AND last_name LIKE :second) OR "
    str2 = "(first_name LIKE :second AND last_name LIKE :first)"
    
    where(str1 + str2, :first => "#{name[0]}%", :second => "#{name[1]}%")
  }

  scope :by_level, lambda { |level|
    return if level.blank?
    str = "level IN (#{('?,' * level.values.count).chop})"
    #convert to array so where will see it as more than 2 args
    where([str] + level.values)
  }

  scope :by_type, lambda { |type|
    return if type.blank?
    str = "customer_type IN (#{('?,' * type.values.count).chop})"
    where([str] + type.values)
  }

  def word_for_type
    case customer_type
    when 1
      "recurring"
    when 2
      "per month"
    when 3
      "package"
    when 4
      "per session"
    end
  end

  private

  def san
    self.first_name = first_name.strip.downcase if self.first_name
    self.last_name = last_name.strip.downcase if self.last_name
    self.customer_number = customer_number.strip if self.customer_number
    self.email = email.strip if self.email
    self.phone_number = phone_number.gsub(/[.-]/, "") if self.phone_number
  end

  def nilify
    case self.customer_type
    when 2
      self.sessions_left = nil
    when 3
      self.paid_through = nil
    else
      self.paid_through = nil
      self.sessions_left = nil
    end
  end

  def validate_paid_through
    errors.add(:paid_through, "must be at least 1 day in the future") if in_past?
  end

  def in_past?
    self.paid_through <= Time.now.to_date if self.paid_through
  end

  def month_to_month?
    self.customer_type == 2
  end

  def package?
    self.customer_type == 3
  end
end
