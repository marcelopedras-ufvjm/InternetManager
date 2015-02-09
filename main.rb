require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'


set :bind, '192.168.1.22'

get '/:lab' do

  lab = params[:lab]
  content_type :json

  case lab
    when 'lab1'
      response = {lab: 1, status: :off}
    when 'lab2'
      response = {lab: 2, status: :off}
    else
      response = {error: 'Undefined lab'}
  end
  response.to_json
end