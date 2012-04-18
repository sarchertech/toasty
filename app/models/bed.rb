class Bed < ActiveRecord::Base
  belongs_to :salon
  has_many :tan_sessions
  has_many :customers, :through => :tan_sessions
  
  before_validation :san

  validates_presence_of :salon_id, :bed_number, :level, :name, :max_time

  validates_inclusion_of :bed_number, :in => 1..15,
                         :message => "must be between 1 and 15"
  validates_inclusion_of :level, :in => 1..6
  validates_inclusion_of :max_time, :in => 5..20

  scope :by_number, order("bed_number")
  
  def session_over?
    tan_session = self.tan_sessions.last
    time = tan_session.minutes + 9 if tan_session
    finished = tan_session.created_at + time.minutes if tan_session
    if tan_session && finished > Time.zone.now 
      return "false"
    else
      return "true"
    end
  end

  private 

  def san
    self.name = name.strip if self.name
  end
end
