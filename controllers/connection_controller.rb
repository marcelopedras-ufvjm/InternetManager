require 'application_controller'
require 'log'
require 'ldapsearch'
require 'json'

class ConnectionController < ApplicationController
  # get '/internet' do
  #   Log.instance.info('teste')
  #   'internet'
  # end

  # get '/searchbygroup/:group' do
  #   content_type :json
  #   group = params[:group]
  #   ldap = LdapSearch.new
  #   result = ldap.search_by_group group
  #   result.to_json
  # end

  before do
    content_type :json
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
    Connection.list.to_json
  end
end