class NflTeam < ActiveRecord::Base
  attr_accessible :location, :name, :abbr
  
  belongs_to :pick
  belongs_to :spread
  
  validates :location, presence: true
  validates :name, presence: true
  validates :abbr, presence: true, uniqueness: true
end
