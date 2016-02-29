class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.string :body
      t.string :url
      t.string :title
     
      
      t.timestamps null: false
    end
  end
end
