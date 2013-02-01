class AddRememberMeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_me, :string
    add_index :users, :remember_me
  end
end
