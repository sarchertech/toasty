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

  validates_presence_of :password_confirmation, :if => :password

  validates_length_of :last_name, :maximum => 40, :minimum => 2
  validates_length_of :first_name, :maximum => 40
  validates_length_of :password, :minimum => 6, :maximum => 20, 
                      :allow_blank => true

  validates_format_of :last_name, :first_name, :without => /[^A-Za-z-]/,
                      :message => "can only contain letters, & hypens, no spaces"
  
  validates_inclusion_of :security_level, :in => 0..4

  validates_confirmation_of :password

  validates_exclusion_of :password, 
                         :in => %w{123456 1234567 12345678 1234567890 password 
                                   qwerty abc123 111111 monkey letmein dragon 
                                   baseball iloveyou sunshine princess tanning 
                                   666666 tigger Password PASSWORD iloveu 
                                   babygirl lovely 654321 password1},
                         :message => "%{value} is not allowed. Please choose a 
                                        more secure password" 

  validate :password_must_not_contain_name, 
           :if => :should_check_if_name_in_password?

  def self.highest_login_like_this(pre)
    where("login LIKE ?", pre + "%").order("login desc").first
  end

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  private

  def should_have_password?
    new_record? || password
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
  end
  
  def auto_create_login
    if login_should_be_changed?
      if user = User.highest_login_like_this(prefix)
        self.login = user.login.gsub(/\d{1,}/) {|s| s.to_i + 1}
      else
        self.login = prefix + "1" 
      end  
    end
  end

  def prefix
    pre = lambda {|n| n.downcase.gsub(/[ -]/,'') }
    
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
