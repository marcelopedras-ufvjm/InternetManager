require 'sinatra/base'
require 'sinatra/reloader'
require 'logger'

class App < Sinatra::Base

  configure do
    #enable :sessions
    #set :sessions_secret, 'vlçajedpofjlçdsmvlasmdgpoasueo9tuqw340t8=-ckb/;smgoqwu3rtuisdpobmas/..n/x.cb184y1025-12-1=-o;/]axzbfkfwqi2oiqryohv.na18309350-kmg.lknawluelkndsagsoluaseoijsadçl;za'
    set :public_folder => './public/'
    set :views => './views/'
    #set :port => 9696   #rackup is ignoring this config
  end

  configure :development do
    register Sinatra::Reloader
  end

  run! if __FILE__ == $0
end