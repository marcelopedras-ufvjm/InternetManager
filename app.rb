require 'sinatra/base'
#require 'logger'
require 'active_support/lazy_load_hooks'
require 'active_support/core_ext/string'

$: << './controllers/'

class App < Sinatra::Base

   Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each do |file|
     file_class = 'app/' + File.basename(file, File.extname(file))
     require file
     use file_class.classify.constantize
   end

  # Dir.glob('./controllers/*.rb').each { |file|
  #   logger =Logger.new(STDOUT)
  #   logger.info(file)
  #   require file
  # }

   # get '/login' do
   #   'test'
   # end

  #$: << './controllers/'
  #Dir.glob('./{controllers}/*.rb').each {|file| require file }

end