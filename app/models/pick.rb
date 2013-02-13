class Pick < ActiveRecord::Base
  attr_accessible :bye, :pick_team_id, :spread_id, :user_id, :wildcard
  
  belongs_to :user
  belongs_to :spread, class_name: "Spread", foreign_key: "spread_id"
  belongs_to :nflTeam, class_name: "NflTeam", foreign_key: "pick_team_id"

  before_save :validate_pick
  
  validates :pick_team_id, presence: true, :inclusion => 1..32
  validates :spread_id, presence: true
  validates :user_id, presence: true
  validates :wildcard, presence: true, :inclusion => 0..5
  
  # Bills favored by 3.5
  # Bills win 28 - 9
  # favored: 28 - 9 - 3.5 = 22.5
  # under: -(28-9) - 3.5 = -17.5
  def calculate_pick
    # Calculate multipliers
    multipliers = 1
    if(self.wildcard > 0)
      multipliers = self.wildcard + 1
    end
    if(self.pick_team_id == self.spread.favored_team_id)
      logger.debug("Pick total: #{self.spread.favored_team_score - self.spread.under_team_score - self.spread.spread}")
      (self.spread.favored_team_score - self.spread.under_team_score - self.spread.spread) * multipliers
    else
      (-(self.spread.favored_team_score - self.spread.under_team_score) + self.spread.spread) * multipliers
    end
  end
  
  def is_bye?
    self.bye
  end
  
  def has_wildcards?
    self.wildcard > 0
  end
  
  def validate_wildcards
    offset = 0
    # Updating a pick
    if(self.id?)
      offset = Pick.find_by_id(self.id).wildcard
    end
    wildcards = Pick.where("user_id = ?", self.user_id).sum(:wildcard) - offset
    unless(self.wildcard + Pick.where("user_id = ?", self.user_id).sum(:wildcard) - offset <= MAX_WILDCARDS)
      errors.add(:pick, "No wildcards left for user")
      false
    end
  end
  
  def validate_pick
    # Update or new pick
    if(self.id?)
      validate_wildcards
    else
      # Check whether spread_id's week and year are found in any other pick
      picks = Pick.where("user_id = ?", self.user_id)
      pick_week = Spread.find_by_id(self.spread_id).week
      pick_year = Spread.find_by_id(self.spread_id).year
      pick_found = false
      picks.each do |pick|
        if(pick_year == pick.spread.year && pick_week == pick.spread.week)
          pick_found = true
        end
      end

      # If pick is not found, it is valid
      return unless(pick_found)
    
      # If pick found and no wildcard specified, +1 to the wildcard
      if(pick_found && self.wildcard == 0)
        self.wildcard += 1
      end
      unless(pick_found && validate_wildcards && self.wildcard > 0)
        errors.add(:pick, "This pick is not valid!")
        false
      end
    end
  end    
end
