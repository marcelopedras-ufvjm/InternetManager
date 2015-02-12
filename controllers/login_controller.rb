require 'application_controller'

class App::LoginController < App::ApplicationController
  get '/bar' do
    'bar'
  end
end