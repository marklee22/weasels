class Pick < ActiveRecord::Base
  attr_accessible :bye, :pick_team_id, :spread_id, :user_id, :wildcard
  
  belongs_to :user
  has_one :pick_team, :class_name => "NflTeam", :primary_key => "pick_team_id", :foreign_key => "id"
  has_many :spreads, :class_name => "Spread", :primary_key => "spread_id", :foreign_key => "id"
  
  validates :bye, presence: true
  validates :pick_team_id, presence: true
  validates :spread_id, presence: true
  validates :user_id, presence: true
  validates :wildcard, presence: true
  
end
