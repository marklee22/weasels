class NflTeam < ActiveRecord::Base
  attr_accessible :location, :name, :abbr
  
  has_many :picks, class_name: "Pick", foreign_key: "pick_team_id"
  has_many :favored_teams, class_name: "Spread", foreign_key: "favored_team_id"
  has_many :under_teams, class_name: "Spread", foreign_key: "under_team_id"
  
  validates_associated :picks
  validates_associated :favored_teams
  validates_associated :under_teams
  
  validates :location, presence: true
  validates :name, presence: true
  validates :abbr, presence: true, uniqueness: true
end
