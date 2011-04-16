class Customer < ActiveRecord::Base
  belongs_to :account
  belongs_to :salon
  has_many :tan_sessions  
  has_many :beds, :through => :tan_sessions

  before_validation :san, :nilify, :set_customer_number

  validate :validate_paid_through, :if => :month_to_month?

  validates_presence_of :last_name, :first_name, :level,
                        :phone_number, :address, :city, :zip_code,
                        :state, :account_id, :salon_id

  validates_presence_of :paid_through, :if => :month_to_month?
  
  validates_numericality_of :phone_number, :zip_code, :allow_blank => true

  validates_numericality_of :sessions_left, :greater_than_or_equal_to => 0, 
                            :if => :package?

  validates_length_of :last_name, :first_name, :maximum => 40
  validates_length_of :phone_number, :is => 10, :allow_blank => true,
                      :message => "must be 10 digits long"
  validates_length_of :zip_code, :is => 5, :allow_blank => true,
                      :message => "must be 5 digits long"

  validates_format_of :last_name, :first_name, :without => /[^A-Za-z-]/,
                      :message => "can only contain letters & hypens-no spaces"
  validates_format_of :email, :with => /^.+@.+\..+$/, :allow_blank => true,
                      :message => "not a valid email"

  validates_inclusion_of :level, :in => 0..5

  validates_inclusion_of :state, :in => %w{AL AK AS AZ AR CA CO CT DE DC FM FL 
                                           GA GU HI ID IL IN IA KS KY LA ME MH 
                                           MD MA MI MN MS MO MT NE NV NH NJ NM 
                                           NY NC ND MP OH OK OR PW PA PR RI SC 
                                           SD TN TX UT VT VI VA WA WV WI WY AE 
                                           AA AP}, :allow_blank => true,
                                           :message => "- %{value} is not a valid
                                                        postal abbreviation"


  #1 == recurring 2 == month to month 3 == by the package 4 == per session
  validates_inclusion_of :customer_type, :in => 1..4

  validates_uniqueness_of :customer_number, :scope => :salon_id

  default_scope :order => 'customers.created_at DESC'

  scope :filter, lambda { |name, level, type|
    by_name(name).by_level(level).by_type(type)
  }

  #add functionality for this later
  scope :by_tanned, lambda { |tanned|
    return if tanned.blank? || tanned[:days].blank? || tanned[:hhn].blank?
    
    if tanned[:hhn] == "have"     
      select('DISTINCT customers.*').
      joins("LEFT JOIN tan_sessions ON customers.id = tan_sessions.customer_id").
      where("tan_sessions.created_at > ?", tanned[:days].to_i.days.ago ) 
    elsif tanned[:hhn] == "have_not"
      select('DISTINCT customers.*').
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

  def details
    case customer_type
    when 2
      "paid through #{paid_through.strftime('%b %d') }"
    when 3
      "#{sessions_left} sessions left"
    end
  end

  def tan
    self.sessions_left -= 1 if customer_type == 3
  end

  def can_tan?
    case customer_type
    when 1
      return true
    when 2
      return true unless expired?
    when 3
      return true if tans_left?
    when 4
      self.errors[:tan] = "No prepaid sessions"
      return false
    end
  end

  private

  def tans_left?
    if self.sessions_left > 0
      return true
    else
      self.errors[:tan] = "No sessions left"
      return false
    end
  end

  def expired?
    if self.paid_through < Time.zone.now.to_date
      self.errors[:tan] = "Membership has expired"
      return true
    end 
  end

  def san
    self.first_name = first_name.strip.downcase if self.first_name
    self.last_name = last_name.strip.downcase if self.last_name
    self.customer_number = customer_number.strip if self.customer_number
    self.email = email.strip if self.email
    self.phone_number = phone_number.gsub(/\D/, "") if self.phone_number
    self.state = state.upcase if self.state
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

  def set_customer_number
    if customer_number.blank?
      set = lambda do
        self.customer_number = "na" + Time.now.usec.to_s
        salon = Salon.find(salon_id)
        customer = salon.customers.find_by_customer_number(customer_number)
        set.call if customer
      end
      set.call
    end
  end

  def validate_paid_through
    error_string = "date must be at least 1 day in the future" 
    errors.add(:paid_through, error_string) if in_past?
  end

  def in_past?
    self.paid_through <= Time.zone.now.to_date if self.paid_through
  end

  def month_to_month?
    self.customer_type == 2
  end

  def package?
    self.customer_type == 3
  end
end
