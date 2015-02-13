require 'application_controller'

class LoginController < ApplicationController

  get '/sign/:user/:password' do
    content_type :json

    user = params[:user]
    password = params[:password]

    ldap = LdapSearch.new
    result = ldap.authenticate(user, password)
    if result
      session[:authenticated] = true
    end
    {authenticated: result}.to_json
  end

  get '/logout' do
    content_type :json
    session.clear
    {authenticated: false}.to_json
  end

  get '/authenticated' do
    content_type :json
    result = authorized?
    {authenticated: result}.to_json
  end
end