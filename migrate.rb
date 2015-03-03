require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

require_relative './models/user'
require_relative './models/connection'
require_relative './models/connection_history'

DataMapper.finalize
DataMapper.auto_migrate!