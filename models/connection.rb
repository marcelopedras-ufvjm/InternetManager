require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
#require_relative '../models/connection_history'



DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Connection

  include DataMapper::Resource

  property :id, Serial
  property :room_name, String
  property :location, String
  property :connection_status, String #on, off
  property :connection_down_start, DateTime
  property :connection_down_end,DateTime

  has n, :connection_histories
  belongs_to :user

  validates_presence_of :room_name, :location, :user
  validates_uniqueness_of :room_name, :location
  validates_with_method :check_status
  validates_with_method :check_off_time

  #validations

  def check_status
    ['on','off'].include?(self.connection_status)
  end

  def check_off_time
    status = true
    if self.connection_status == 'off'
      if self.connection_down_end && self.connection_down_start
        if self.connection_down_end < self.connection_down_start
          status = [false,'Connection status é off, logo o horário de religamento da internet deve ser maior que o horário de desligamento']
        end
      else
        status = [false, 'Connection down end ou Connection down start são nulos, porém connection status esta off']
      end
    end

    status
  end


  def on
    self.connection_status = 'on'
    self.connection_down_start = nil
    self.connection_down_end = nil
  end

  def off(end_time, user)
    self.connection_status = 'off'
    self.connection_down_start = DateTime.now()
    self.connection_down_end = end_time
    self.user = user
  end

  def save

    ch=ConnectionHistory.new
    ch.connection_status = self.connection_status
    ch.created_at = DateTime.now
    ch.user = self.user
    ch.connection = self
    ch.save
  end

  def list_history
    self.connection_histories.map do |ch|
      [
          ch.created_at.strftime("%d/%m/%Y %H:%M:%S"), #created_time
          ch.user.username,                            #user
          self.room_name,                              #laboratório
          self.location,                               #sala
          ch.connection_status                         #status da internet
      ]
    end
  end
end

#DataMapper.finalize