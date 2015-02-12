require 'application_controller'
require 'log'
require 'ldapsearch'
require 'json'

class App::InternetController < App::ApplicationController
  get '/internet' do
    Log.instance.info('teste')
    'internet'
  end

  get '/searchbygroup/:group' do
    content_type :json
    group = params[:group]
    ldap = LdapSearch.new
    result = ldap.search_by_group group
    puts result[1]
    result.to_json
  end
end