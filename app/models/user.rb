class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :admin, :team_name
  
  has_many :picks, dependent: :destroy
  validates_associated :picks
  
  before_save :create_remember_token
  after_initialize :init
  before_save { |user| user.email = email.downcase }

  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :email, :presence => true, :uniqueness => { :case_sensitive => false },
    length: { :maximum => 254 }, :format => { :with => VALID_EMAIL_REGEX }
  validates :first_name, :presence => true, length: { :maximum => 35 }
  validates :last_name, :presence => true, length: { :maximum => 35 }
  validates :password, :presence => true, length: { :minimum => 6 }
  validates :password_confirmation, :presence => true
  
  def init
    self.admin ||= false
    self.team_name ||= "Team #{self.last_name}"
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def pick_last_week
    last_pick = ""
    # NFL regular season is 17 weeks
    if(NFL_WEEK > 0 && NFL_WEEK <= 17+1)
      picks = self.picks.select{|pick| spread = Spread.find_by_id(pick.spread_id)
        spread.week == NFL_WEEK-1 && spread.year == NFL_YEAR}
      ctr = 1
      picks.each do |pick|
        last_pick << "#{pick.nflTeam.team_name}"
        if(pick.wildcard > 1)
          last_pick << " x#{pick.wildcard}"
        end
        logger.info("#{picks.length} == #{ctr}")
        if(picks.length != ctr)
          last_pick << ", "
        end
        ctr += 1
      end
    end
    if(last_pick.empty?)
      '-'
    else
      last_pick
    end
    
  end
  
  def total_score
    total = 0
    picks = Pick.find_all_by_user_id(self.id)
    picks.each do |pick|
      if(pick.spread.year == NFL_YEAR)
        total += pick.calculate_pick
      end
    end
    total
  end
  
  private
    def create_remember_token
      begin
        self.remember_token = SecureRandom.urlsafe_base64
      end while self.class.exists?(:remember_token => remember_token)
    end  
end
