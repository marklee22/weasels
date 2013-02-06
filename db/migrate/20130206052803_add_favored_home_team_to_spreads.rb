class AddFavoredHomeTeamToSpreads < ActiveRecord::Migration
  def change
    add_column :spreads, :is_favored_home_team, :boolean
  end
end
