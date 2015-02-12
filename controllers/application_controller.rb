require 'sinatra/base'

class App::ApplicationController < Sinatra::Base
  get '/foo' do
    'foo'
  end
end