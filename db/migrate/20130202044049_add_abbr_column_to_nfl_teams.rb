class AddAbbrColumnToNflTeams < ActiveRecord::Migration
  def change
    add_column :nfl_teams, :abbr, :string
  end
end
