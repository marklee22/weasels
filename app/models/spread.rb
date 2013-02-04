class Spread < ActiveRecord::Base
  attr_accessible :favored_team_id, :spread, :under_team_id, :week, :year, :favored_won

  has_many :picks
  belongs_to :favored_team, class_name: "NflTeam", foreign_key: "favored_team_id"
  belongs_to :under_team, class_name: "NflTeam", foreign_key: "under_team_id"
  
  validates_associated :picks
  
  validates :favored_team_id, presence: true, :inclusion => 1..32
  validates :under_team_id, presence: true, :inclusion => 1..32
  validates :spread, presence: true
  validates :week, presence: true
  validates :year, presence: true
  
end
