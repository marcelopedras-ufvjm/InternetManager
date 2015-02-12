require 'sinatra/base'
require 'logger'
require 'active_support/lazy_load_hooks'
require 'active_support/core_ext/string'

$: << './controllers/'
$: << './lib/'

class App < Sinatra::Base

   Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each do |file|
     file_class = 'app/' + File.basename(file, File.extname(file))
     require file
     use file_class.classify.constantize
   end

   # get '/login' do
   #   'test'
   # end

  # $: << './controllers/'
  # Dir.glob('./{controllers}/*.rb').each {|file|
  #   #logger.info(file)
  #   require file
  # }
  #
  # use LoginController
  # use InternetController

end