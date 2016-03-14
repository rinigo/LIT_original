class AddGoodIdToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :good, :interger, default: 0
  end
end
