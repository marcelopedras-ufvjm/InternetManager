require 'application_controller'
require 'log'
require 'ldapsearch'
require 'json'

class InternetController < ApplicationController
  get '/internet' do
    Log.instance.info('teste')
    'internet'
  end

  get '/searchbygroup/:group' do
    content_type :json
    group = params[:group]
    ldap = LdapSearch.new
    result = ldap.search_by_group group
    result.to_json
  end
end