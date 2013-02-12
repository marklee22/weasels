class AddAdminAndTeamNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean
    add_column :users, :team_name, :string
  end
end
