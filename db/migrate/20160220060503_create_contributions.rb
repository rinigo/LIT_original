class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.string :name
      t.string :body
      t.string :mail
      t.string :password_digest
      t.string :url
      t.string :title
      
      t.timestamps null: false
    end
  end
end
