require_relative './models/user'
require_relative './models/connection'
require_relative './models/connection_history'

env = ARGV[0]
path =  "sqlite3://#{Dir.pwd}"

puts path

if env == 'production'
  DataMapper.setup(:default, "#{path}/production.db")
elsif env == 'test'
  DataMapper.setup(:default, "#{path}/test.db")
else
  DataMapper.setup(:default, "#{path}/development.db")
end

u=User.first(username: 'automatic')
u = User.new unless u

u.username = 'automatic'
u.password = ENV['AUTOMATIC_PW']  #'123456'
u.create_token
u.refresh_time_live
puts "usuario valido? #{u.valid?}"
u.save

c1=Connection.first(room_name: 'lab1')
c1 = Connection.new unless c1

c1.user = u
c1.room_name = 'lab1'
c1.location = 'sala 252'
c1.ip_range = '192.168.11.0/24'
c1.on
c1.save

c2=Connection.first(room_name: 'lab2')
c2 = Connection.new unless c2

c2.user = u
c2.room_name = 'lab2'
c2.location = 'sala 255'
c2.ip_range = '192.168.12.0/24'
c2.on
c2.save

c3=Connection.first(room_name: 'lab3')
c3 = Connection.new unless c3

c3.user = u
c3.room_name = 'lab3'
c3.location = 'sala 355'
c3.ip_range = '192.168.13.0/24'
c3.on
c3.save

c4=Connection.first(room_name: 'lab4')
c4 = Connection.new unless c4

c4.user = u
c4.room_name = 'lab4'
c4.location = 'sala 356'
c4.ip_range = '192.168.14.0/24'
c4.on
c4.save

c5=Connection.first(room_name: 'lab5')
c5 = Connection.new unless c5

c5.user = u
c5.room_name = 'lab5'
c5.location = 'sala 361'
c5.ip_range = '192.168.15.0/24'
c5.on
c5.save