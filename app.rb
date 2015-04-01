require 'sinatra/base'
require 'sinatra/reloader'
require 'logger'

class App < Sinatra::Base

  configure do
    set :public_folder => './public/'
    set :views => './views/'
    #set :port => 9696   #rackup is ignoring this config
  end

  configure :production do
    #production configuration here
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/production.db")
  end

  configure :development do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
    register Sinatra::Reloader
    #ENV['SQUID_HOST'] = "192.168.70.33"
    #ENV['INTERNET_MANAGER_HOST'] = "192.168.70.34"
    #ENV['LDAP_HOST'] = "192.168.70.35"
    #ENV['APP_ENVIRONMENT'] = "devlopment"
    #ENV['AUTOMATIC_PW']="123456"
    #ENV['ATTR_ENCRYPTED_PW']="123456"
  end

  configure :test do
    #test configuration here
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/test.db")
  end

  run! if __FILE__ == $0
end