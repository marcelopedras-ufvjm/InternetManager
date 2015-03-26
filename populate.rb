require_relative './models/user'
require_relative './models/connection'
require_relative './models/connection_history'
u1=User.first(username: 'carol')
u1 = User.new unless u1
u1.username = 'carol'
u1.password = '123456'
u1.create_token
u1.refresh_time_live
u1.save

u2=User.first(username: 'automatic')
u2 = User.new unless u2
u2 = User.new
u2.username = 'automatic'
u2.password = '123456'
u2.create_token
u2.refresh_time_live
u2.save

c1=Connection.first(room_name: 'lab1')
c1 = Connection.new unless c1

c1.user = u1
c1.room_name = 'lab1'
c1.location = 'sala 255'
c1.ip_range = '192.168.11.0/24'
c1.on
c1.save

c2=Connection.first(room_name: 'lab2')
c2 = Connection.new unless c2

c2.user = u1
c2.room_name = 'lab2'
c2.location = 'sala 356'
c2.ip_range = '192.168.12.0/24'
c2.on
c2.save


c3=Connection.first(room_name: 'test')
c3 = Connection.new unless c3
c3.user = u1
c3.room_name = 'test'
c3.location = 'sala test'
c3.ip_range = '192.168.1.0/24'
c3.on
c3.save

c4=Connection.first(room_name: 'test2')
c4 = Connection.new unless c4

c4.user = u1
c4.room_name = 'test2'
c4.location = 'sala test2'
c4.ip_range = '192.168.2.0/24'
c4.on
c4.save


