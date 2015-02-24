require 'dm-core'
require 'dm-migrations'
require 'dm-validations'


DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class ConnectionHistory
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime, :required => true
  property :connection_status, String, :required => true

  belongs_to :connection
  belongs_to :user

  validates_presence_of :connection_status, :user, :connection
  validates_with_method :check_connection_status

  def check_connection_status
    ['on', 'off'].include?(self.connection_status)
  end



end


#DataMapper.finalize