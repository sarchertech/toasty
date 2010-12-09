class User < ActiveRecord::Base
  belongs_to :account
  belongs_to :salon

  before_validation :san

  before_save :auto_create_login

  validates_presence_of :last_name, :first_name, :security_level, :account_id

  validates_length_of :last_name, :maximum => 40, :minimum => 2
  validates_length_of :first_name, :maximum => 40

  validates_format_of :last_name, :first_name, :without => /[^A-Za-z -]/,
                      :message => "can only contain letters, spaces, and hypens"
  
  validates_inclusion_of :security_level, :in => 1..4

  def self.highest_login_like_this(pre)
    where("login LIKE ?", pre + "%").order("login desc").first
  end
  
  private

  def san
    self.last_name = last_name.strip if self.last_name
    self.first_name = first_name.strip if self.first_name
  end

  def auto_create_login
    if login_should_not_be_changed?
    elsif user = User.highest_login_like_this(prefix)
      self.login = user.login.gsub(/\d{1,}/) {|s| s.to_i + 1}
    else
      self.login = prefix + "1" 
    end
  end

  def prefix
    pre = lambda {|n| n.downcase.gsub(/[ -]/,'') }
    
    (pre.call self.first_name)[0] + (pre.call self.last_name)[0..5]
  end

  def login_should_not_be_changed?
    if self.login == nil
      false
    elsif self.first_name_changed? || self.last_name_changed?
      prefix == self.login.gsub(/\d{1,}/,'')
    else
      true
    end
  end
end
