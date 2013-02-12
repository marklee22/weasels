class Spread < ActiveRecord::Base
  attr_accessible :favored_team_id, :spread, :under_team_id, :week, :year, :favored_won, :is_favored_home_team

  has_many :picks
  belongs_to :favored_team, class_name: "NflTeam", foreign_key: "favored_team_id"
  belongs_to :under_team, class_name: "NflTeam", foreign_key: "under_team_id"
  
  validates_associated :picks
  
  validates :favored_team_id, presence: true, :inclusion => 1..32
  validates :under_team_id, presence: true, :inclusion => 1..32
  validates :spread, presence: true
  validates :week, presence: true, :inclusion => 1..22
  validates :year, presence: true, :inclusion => 2000..2020
  validates_uniqueness_of :favored_team_id, :scope => [:week, :year]
  validates_uniqueness_of :under_team_id, :scope => [:week, :year]
  # validates_uniqueness_of :week, :scope => :under_team_id

  def self.build_from_csv(row, week, year)
    spread = Spread.new(favored_team_id: find_team_id(row[1]), spread: row[2].to_f.abs,
        under_team_id: find_team_id(row[3]), is_favored_home_team: is_home_team?(row[1]), week: week, year: year)
  end
  
  def self.is_home_team?(team)
    if(team.match('^[Aa][Tt] '))
      true
    else
      false
    end
  end
  
  def self.find_team_id(lookup)
    lookup = sanitize_team_name(lookup)
    if(team = NflTeam.find_by_abbr(lookup))
    elsif(team = NflTeam.find_by_name(lookup))
    elsif(team = NflTeam.find_by_location(lookup))
    else
      return 1
    end
    team.id
  end
  
  def self.sanitize_team_name(name)
    if(name.include?('NY '))
      name = name.sub('NY ', '')
    end
    if(name.include?('At '))
      name = name.sub('At ', '')
    end
    name = name.sub('.','')
    name
  end
  
  # Download the nfl scores for the current week
  def self.download_scores
    puts "Test function"
  end
        
end
