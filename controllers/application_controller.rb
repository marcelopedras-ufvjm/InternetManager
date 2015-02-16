require 'sinatra/base'
require 'app'

class ApplicationController < App



  # before do
  #   puts 'passou aqui'
  # end

  def authorized?
     puts session[:authenticated]
     !!session[:authenticated]
   end

  get '/foo' do
    'foo'
  end

  get '/twitter_template.html' do
    #content_type :html
    #erb :twitter_template
  end

  get '/' do
    erb :index
    #erb :'public/app/index'
    #content_type :html
    #erb :twitter_template
  end
end