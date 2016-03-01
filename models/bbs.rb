ActiveRecord::Base.establish_connection(
  ENV['DATABASE_URL']||'sqlite3:db/development.db')

class Contribution < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  
  # class method
  def self.categories 
    pluck(:category).select{|category| !category.nil?}.uniq
  end
end

class User < ActiveRecord::Base
  has_secure_password
  has_many :contributions
end
