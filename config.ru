#\ -w -o 0.0.0.0 -p 9696
require 'sinatra/base'
require 'logger'
require 'bundler'

Bundler.require

$: << './controllers/'
$: << './models/'
$: << './lib/'
$: << '.'

Dir.glob('./{controllers,models,lib}/*.rb').each {|file|
 #logger.info(file)
 require file
}

#require './app.rb'

run Rack::URLMap.new({
                         "/connection" => ConnectionController,
                         "/login" => LoginController,
                         "/" => ApplicationController
                     })

