require 'sinatra/base'
require 'app'

class ApplicationController < App
  before do
    check_token
  end

  def check_token
    skip_check_token_paths = %w"
    /login/sign
    /login/logout
    /login/authenticate_by_token
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
end