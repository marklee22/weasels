class Pick < ActiveRecord::Base
  attr_accessible :bye, :pick_team_id, :spread_id, :user_id, :wildcard
  
  belongs_to :user
  belongs_to :spread
  belongs_to :nflTeam, class_name: "NflTeam", foreign_key: "pick_team_id"

  
  validates :pick_team_id, presence: true, :inclusion => 1..32
  validates :spread_id, presence: true
  validates :user_id, presence: true
  validates :wildcard, presence: true, :inclusion => 0..5
  
end
