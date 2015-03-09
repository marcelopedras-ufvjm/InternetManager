require 'sinatra/base'
require 'app'

class ApplicationController < App
  before do
    check_token
  end

  def authorized?
     puts session[:authenticated]
     !!session[:authenticated]
  end

  def check_token
    skip_check_token_paths = %w"
    /login/sign
    /login/logout
    /login/authenticate_by_token
    /data
    /
    /connection/list
    /connection/squid_sync
    "

    unless skip_check_token_paths.include? request.path
      token = env['HTTP_AUTH_BY_TOKEN'] #params['token']
      unless token && User.authenticate_by_token(token)
        content_type :json
        resp = {
            'authenticated' => false,
            'error' => 'Invalid or expired token. Try sign again'
        }

        halt(401,resp.to_json)
      end

      @user = User.authenticate_by_token(token)
    end
  end

  get '/' do
    content_type :html
    erb :index
  end

  get '/data' do
    content_type :json
    data = [
        {
            numero: 1,
            sala: 255,
            internet: true,
            by: nil,
            start_time: nil,
            end_time: nil
        },
        {
            numero: 2,
            sala: 305,
            internet: false,
            by: 'José',
            start_time: '17:00',
            end_time: '19:00'
        },
        {
            numero: 3,
            sala: 335,
            internet: true,
            by: nil,
            start_time: nil,
            end_time: nil
        },
        {
            numero: 4,
            sala: 252,
            internet: false,
            by: 'Marcelo',
            start_time: '07:00',
            end_time: '09:00'
        },
        {
            numero: 5,
            sala: 260,
            internet: true,
            by: nil,
            start_time: nil,
            end_time: nil
        }
    ]
    data.to_json
  end
end