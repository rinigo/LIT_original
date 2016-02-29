ActiveRecord::Base.establish_connection(
  ENV['DATABASE_URL']||'sqlite3:db/development.db')

class Contribution < ActiveRecord::Base
  belongs_to :user
end

class User < ActiveRecord::Base
  has_secure_password
  has_many :contributions
end
