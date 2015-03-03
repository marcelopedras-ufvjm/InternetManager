require_relative './models/user'
require_relative './models/connection'
require_relative './models/connection_history'

u = User.new
u.username = 'carol'
u.password = '123456'
u.create_token
u.refresh_time_live
u.save

c1 = Connection.new

c1.user = u
c1.room_name = 'lab1'
c1.location = 'sala 255'
c1.on
c1.save

c2 = Connection.new

c2.user = u
c2.room_name = 'lab2'
c2.location = 'sala 356'
c2.on
c2.save
