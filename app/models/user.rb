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

  private

  def san
    self.last_name = last_name.strip if self.last_name
    self.first_name = first_name.strip if self.first_name
  end

  def auto_create_login
    last = self.last_name.downcase.gsub(/[ -]/,'')[0..5]
    first = self.first_name.downcase.gsub(/[ -]/,'')[0]

    prefix = first + last 

    if user = User.where("login LIKE ?", "#{prefix}%").order("login desc").first
      self.login = user.login.gsub(/\d{1,}/) {|s| s.to_i + 1}
    else
      self.login = "#{prefix}1" 
    end
  end
end
