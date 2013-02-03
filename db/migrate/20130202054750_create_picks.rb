class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.integer :user_id
      t.integer :pick_team_id
      t.integer :spread_id
      t.integer :wildcard
      t.boolean :bye

      t.timestamps
    end
    add_index :picks, :user_id
    add_index :picks, :spread_id
  end
end
