require 'application_controller'
require 'log'
require 'ldapsearch'
require 'json'
require 'rest_client'

class ConnectionController < ApplicationController

  before do
    content_type :json

    skip_check_token_paths = %w"
    /connection/squid_sync
    "
    begin
      if skip_check_token_paths.include? request.path
        squid_key =  params['squid_key']
        authorized? squid_key
      end
    rescue => e
      to_halt
    end
  end

  def authorized? squid_key
    unless squid_key == ENV['SQUID_KEY'] #App.settings.squid_key
      to_halt
    end
  end

  def to_halt
    content_type :json
    resp = {
        'authorized' => false,
        'error' => 'Invalid Squid key.'
    }

    halt(401,resp.to_json)
  end

  get '/list' do
    # content_type :json
    Connection.list.to_json
  end

  post '/set' do
    id = params['id']
    start_time = params['start_time']
    end_time = params['end_time']
    internet = params['internet'] == "true" ? true : false
    by = params['by']

    c=Connection.first(id: id)
    c.connected = internet
    # DateTime.strftime("%d/%m/%Y %H:%M:%S"),
    start_time_p = (start_time == 'n/a' ? nil : DateTime.strptime( start_time,"%H:%M"))
    end_time_p = (end_time == 'n/a' ? nil : DateTime.strptime(end_time,"%H:%M"))
    c.connection_down_start = start_time_p #== 'n/a' ? nil : DateTime.strptime( start_time,"%H:%M")
    c.connection_down_end = end_time_p #== 'n/a' ? nil : DateTime.strptime(end_time,"%H:%M")
    c.user = @user
    c.save
    result_sync = Connection.sync
    result_sync.to_json
    #{success: Connection.squid_sync}.to_json
    #Connection.list.to_json
  end

  post '/squid_sync' do
    #squid_key = params['squid_key']
    #puts squid_key
    data = params['data']
    labs=JSON.parse(data)
    Connection.sync(labs)
    labs.to_json
  end
end