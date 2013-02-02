class CreateNflTeams < ActiveRecord::Migration
  def change
    create_table :nfl_teams do |t|
      t.string :location
      t.string :name

      t.timestamps
    end
    add_index :nfl_teams, :location
    add_index :nfl_teams, :name
  end
end
