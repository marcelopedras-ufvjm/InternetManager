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
                         "/ldap" => InternetController,
                         "/login" => LoginController,
                         "/" => ApplicationController
                     })

