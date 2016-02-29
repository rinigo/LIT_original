class OrganizeTables < ActiveRecord::Migration
  def change
    remove_column :users, :user_id, :integer
    remove_column :contributions, :category_id, :integer
    drop_table :categories
  end
end
