require 'csv'
require 'nokogiri'
require 'open-uri'

class Spread < ActiveRecord::Base
  attr_accessible :favored_team_id, :spread, :under_team_id, :week, :year, :favored_won, :is_favored_home_team

  has_many :picks, dependent: :destroy
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
  
  # Populate spreads based on the txt files in Rails.root/public/uploads
  def self.populate_spreads
    success = failed = 0
    failures = []
    Dir.foreach("#{Rails.root}/public/uploads") do |file|
      next unless(file.end_with?('.txt'))
      tokens = file.sub('.txt','').split("-")
      
      # Skip invalid files
      next if(tokens.length != 2 && tokens[0].length != 4)
      
      nfl_week = tokens[1]
      nfl_year = tokens[0]
      Spread.delete_all("week = #{nfl_week} and year = #{nfl_year}")
      CSV.foreach("#{Rails.root}/public/uploads/#{file}", { :col_sep => "\t", :headers => true } ) do |row|
        spread = build_from_csv(row, nfl_week, nfl_year)
        if(spread.save)
          success += 1
        else
          failures << row
          failed += 1
        end
      end
    end
    "Success: #{success}, Failed: #{failed}"
  end
  
  def self.find_spread(home_team, away_team, year, week)
    home_team = find_team_id(home_team)
    away_team = find_team_id(away_team)
    spread1 = Spread.where('favored_team_id = ? AND under_team_id = ? AND year = ? AND week = ?', home_team, away_team, year, week)
    logger.info(spread1)
    spread2 = Spread.where('favored_team_id = ? AND under_team_id = ? AND year = ? AND week = ?', away_team, home_team, year, week)
    logger.info(spread2)
    if(spread1.empty? && spread2.empty?)
      logger.info("returning empty")
      nil
    elsif(spread1.empty?)
      logger.info("returning spread2")
      spread2.first
    else
      logger.info("returning spread1")
      spread1.first
    end
  end
  
  # Screen scrape scores from nfl.com and populate the scores in the database for each spread
  def self.update_scores(year, week)
    if(week < 1 || week > 17)
      abort("Invalid week number")
    end
    url = "http://www.nfl.com/scores/"+year.to_s+"/REG"+week.to_s
    begin
      doc = Nokogiri::HTML(open(url))
    rescue
      abort("Error: Could not open URL (#{url})")
    end

    # Process each score
    scores = doc.xpath('.//div[@class="new-score-box"]')
    scores.each do |score|
      begin
        homeTeam = score.xpath('.//div[@class="home-team"]/div/div/p[@class="team-name"]/a').text
        homeTeamScore = score.xpath('.//div[@class="home-team"]/div/p[@class="total-score"]').text
        awayTeam = score.xpath('.//div[@class="away-team"]/div/div/p[@class="team-name"]/a').text
        awayTeamScore = score.xpath('.//div[@class="away-team"]/div/p[@class="total-score"]').text
        puts "#{homeTeam} (#{homeTeamScore}) vs. #{awayTeam} (#{awayTeamScore})"
      rescue
        puts "Could not scrape teams/scores from #{url}"
      end
      
      begin
        spread = find_spread(homeTeam,awayTeam,year,week)
        if(spread.nil?)
          puts "No Spread found.  Did not update: #{homeTeam} vs. #{awayTeam}"
        else
          # Determine whether home team is favored and update scores
          if(spread.is_favored_home_team)
            spread.favored_team_score = homeTeamScore
            spread.under_team_score = awayTeamScore
          else
            spread.favored_team_score = awayTeamScore
            spread.under_team_score = homeTeamScore
          end
          
          # Determine whether the favored team won the game or not
          if(spread.favored_team_score > spread.under_team_score)
            spread.favored_won = true
          else
            spread.favored_won = false
          end          
          
          # Update the spread
          spread.save
        end
      rescue
        puts "Could not save Score for spread"
      end
    end
  end
  
  # Update all the scores found in the database
  def self.update_all_scores
    (1..17).each do |week|
      update_scores(2012,week)
    end
  end
        
end
