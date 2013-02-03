class CreateSpreads < ActiveRecord::Migration
  def change
    create_table :spreads do |t|
      t.integer :year
      t.integer :week
      t.integer :favored_team_id
      t.integer :under_team_id
      t.decimal :spread
      t.boolean :favored_won

      t.timestamps
    end
    add_index :spreads, :year
    add_index :spreads, :week
  end
end
