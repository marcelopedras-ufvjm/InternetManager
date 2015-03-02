require 'dm-core'
require 'dm-migrations'
require 'dm-validations'


DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class ConnectionHistory
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime, :required => true
  property :connected, Boolean, :required => true

  belongs_to :connection
  belongs_to :user

  validates_presence_of :connected, :user, :connection

end


#DataMapper.finalize