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
end