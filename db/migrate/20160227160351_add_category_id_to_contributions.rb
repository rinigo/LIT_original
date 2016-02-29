class AddCategoryIdToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :category_id, :integer
  end
end
