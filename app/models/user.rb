class User < ActiveRecord::Base
  belongs_to :account
  belongs_to :salon

  before_validation :san

  validates_presence_of :last_name

  validates_length_of :last_name, :maximum => 40
  
  validates_format_of :last_name, :without => /[^A-Za-z -]/,
                      :message => "can only contain letters, spaces, and hypens"


  private

  def san
    self.last_name = last_name.strip if self.last_name
  end
end
