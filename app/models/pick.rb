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
  
  def picked_favored?
    self.pick_team_id == self.spread.favored_team.id
  end
  
  # Calculate the net gain or loss of the pick based on the scores
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
  
  def validate_wildcards
    offset = 0
    # Updating a pick
    if(self.id?)
      offset = Pick.find_by_id(self.id).wildcard
    end
    usedWildcards = Pick.where("user_id = ?", self.user_id).sum(:wildcard)
    # logger.debug("***usedWildcards: #{usedWildcards}, offset: #{offset}, curr:#{self.wildcard}***")
    if(self.wildcard + usedWildcards - offset <= MAX_WILDCARDS)
      return true
    else
      errors.add(:pick, "No wildcards left for user")
      false
    end
  end
  
  def validate_pick
    # Updating an existing pick
    if(self.id?)
      validate_wildcards
    # New pick
    else
      # Check whether user made a pick already for the same week and year
      picks = Pick.where("user_id = ?", self.user_id)
      pick_week = Spread.find_by_id(self.spread_id).week
      pick_year = Spread.find_by_id(self.spread_id).year
      same_week_pick = false
      picks.each do |pick|
        if(pick_year == pick.spread.year && pick_week == pick.spread.week)
          same_week_pick = true
        end
      end

      # If no pick is found for that week/year, it is valid
      return unless(same_week_pick)
      # logger.debug("***Pick found for that week***")
    
      # Increment wildcard if none was specified since this is a same week pick
      if(self.wildcard == 0)
        self.wildcard += 1
      end
      # logger.debug("***Wildcards: #{self.wildcard}***")
      
      # Invalid pick if wildcards are invalid
      unless(validate_wildcards)
        # logger.debug("***#{validate_wildcards}***")
        errors.add(:pick, "This pick is not valid.")
        false
      end
    end
  end    
end
