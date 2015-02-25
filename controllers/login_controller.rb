require 'application_controller'

class LoginController < ApplicationController

  post '/sign' do

    content_type :json

    user = params['user']
    password = params['password']
    #TODO Marcelo  - Tratar o caso de groupos de professores e de admins de laboratório
    group = params['group']

    resp = {
        'authenticated' => false
    }

    u = User.sign(user, password)
    if u
      resp['authenticated'] = true
      resp['token'] = u.token
      resp['user'] = u.username
    else
      halt(401,resp.to_json)
    end
    resp.to_json
  end

  post '/logout' do
    content_type :json

    token = params['token']
    u=User.authenticate_by_token(token)
    u.expire_token_time if u

    {authenticated: false, logout: true}.to_json
  end

  post '/authenticate_by_token' do
    content_type :json
    token = params['token']

    resp = {
        'authenticated' => false
    }

    u=User.authenticate_by_token(token)

    if u
      resp['authenticated'] = true
      resp['token'] = u.token
      resp['user'] = u.username
    else
      resp['error'] = 'Invalid or expired token. Try sign again'
      halt(401,resp.to_json)
    end
    resp.to_json
  end

  # get '/authenticated' do
  #   content_type :json
  #   result = authorized?
  #   {authenticated: result}.to_json
  # end

  post '/test' do
    data = params
    data.to_json
  end
end