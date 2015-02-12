#require 'sinatra/base'
#require 'application_controller'

class App::InternetController < App::ApplicationController
  get '/internet' do
    'internet'
  end
end