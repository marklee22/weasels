class RenameRememberMeColumnNameToUsers < ActiveRecord::Migration
  def up
    rename_column :users, :remember_me, :remember_token
  end

  def down
  end
end
