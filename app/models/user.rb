require 'digest'
class User < ActiveRecord::Base
  belongs_to :account
  belongs_to :salon

  attr_accessor :password

  before_validation :san

  before_save :auto_create_login
  before_save :encrypt_password, :if => :password

  validates_presence_of :last_name, :first_name, :security_level, :account_id
                        
  validates_presence_of :password, :if => :should_have_password?

  validates_presence_of :password_confirmation, :if => :password_present?

  validates_length_of :last_name, :maximum => 40, :minimum => 2
  validates_length_of :first_name, :maximum => 40
  validates_length_of :password, :minimum => 6, :maximum => 20, 
                      :allow_blank => true

  validates_format_of :last_name, :first_name, :without => /[^A-Za-z-]/,
                      :message => "can only contain letters, & hypens, no spaces"
  
  validates_inclusion_of :security_level, :in => 0..4

  validates_confirmation_of :password, :if => :password_present?

  validates_exclusion_of :password, 
                         :in => %w{123456 1234567 12345678 1234567890 password 
                                   qwerty abc123 111111 monkey letmein dragon 
                                   baseball iloveyou sunshine princess tanning 
                                   666666 tigger Password PASSWORD iloveu 
                                   babygirl lovely 654321 password1 toasty
                                   toasty24 Toasty Toasty24 TOASTY TOASTY24},
                         :message => "%{value} is not allowed. Please choose a 
                                        more secure password" 

  validate :password_must_not_contain_name, 
           :if => :should_check_if_name_in_password?

  def self.highest_login_like_this(pre)
    where("login LIKE ?", pre + "%").order("login_suffix desc").first
  end

  def has_password?(submitted_password)
    if encrypted_password == encrypt(submitted_password)
      self.password_attempts = 0
      self.save!
      true
    else
      wrong_password
      false
    end
  end

  def too_many_tries?
    if password_attempts > 24
      true
    elsif password_attempts > 19 && wrong_attempt_at > 15.minutes.ago
      true
    elsif password_attempts > 14 && wrong_attempt_at > 10.minutes.ago
      true
    elsif password_attempts > 9 && wrong_attempt_at > 5.minutes.ago
      true 
    end
  end

  def how_long
    if password_attempts > 24    
      "contact an owner or manger to reset your password (if you are an owner please call our tech support number and we will reset your password for you)"
    elsif password_attempts > 19
      "wait 15 minutes"
    elsif password_attempts > 14
      "wait 10 minutes"
    elsif password_attempts > 9
      "wait 5 minutes"
    end
  end

  def word_for_security_level
    case security_level
    when 1
      "employee"
    when 2
      "manager"
    when 3
      "owner"
    end
  end

  def can_work_here?(s_id)
    self.salon_id == s_id || self.access_all_locations? 
  end

  private
  
  def wrong_password
    self.password_attempts += 1
    self.wrong_attempt_at = Time.zone.now
    save!
  end

  def should_have_password?
    new_record? || password
  end

  def password_present?
    password.present?
  end

  def password_must_not_contain_name
    if password_includes_name?
      errors.add(:password, "is too similar to name")
    end  
  end

  def should_check_if_name_in_password?
    password && first_name && last_name
  end

  def password_includes_name?
    password.include?(first_name[0...4]) || password.include?(last_name[0..4])
  end

  def san
    self.last_name = last_name.strip.downcase if self.last_name
    self.first_name = first_name.strip.downcase if self.first_name
    self.password = nil if password.blank? # nil password to allow blank form
  end
  
  def auto_create_login
    if login_should_be_changed?
      if user = User.highest_login_like_this(prefix)
        self.login = user.login.gsub(/\d{1,}/) {|s| @s = s.to_i + 1}
        self.login_suffix = @s
      else
        self.login = prefix + "1" 
      end  
    end
  end

  def prefix
    pre = lambda {|n| n.downcase.gsub(/[ -]/,'') }
    
    #may not work with ruby 1.8.7
    (pre.call self.first_name)[0] + (pre.call self.last_name)[0..5]
  end

  def login_should_be_changed?
    if self.login
      f = first_name_changed?
      l = last_name_changed?

      ( f || l) && prefix != login.gsub(/\d{1,}/,'')
    else
      true 
    end
  end

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password) 
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}") 
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end
