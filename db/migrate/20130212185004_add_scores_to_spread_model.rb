class AddScoresToSpreadModel < ActiveRecord::Migration
  def change
    add_column :spreads, :favored_team_score, :integer
    add_column :spreads, :under_team_score, :integer
  end
end
