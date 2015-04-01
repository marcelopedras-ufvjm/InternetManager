require 'dm-core'
require 'dm-migrations'


if ENV['APP_ENVIRONMENT'] == 'production'
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/production.db")
elsif ENV['APP_ENVIRONMENT'] == 'test'
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
else
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end


DataMapper::Logger.new($stdout, :debug)

require_relative './models/user'
require_relative './models/connection'
require_relative './models/connection_history'

DataMapper.finalize
DataMapper.auto_migrate!