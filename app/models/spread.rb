class Spread < ActiveRecord::Base
  attr_accessible :favored_team_id, :spread, :under_team_id, :week, :year, :favored_won

  belongs_to :pick  
  has_many :favored_team, class_name: "NflTeam", primary_key: "favored_team_id", foreign_key: "id"
  has_many :under_team, class_name: "NflTeam", primary_key: "under_team_id", foreign_key: "id"
  
  validates :favored_team_id, presence: true
  validates :under_team_id, presence: true
  validates :spread, presence: true
  validates :week, presence: true
  validates :year, presence: true
  
end
