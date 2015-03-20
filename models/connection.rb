require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
require 'dm-timestamps'
#require_relative '../models/connection_history'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Connection

  include DataMapper::Resource

  property :id, Serial
  property :room_name, String, :required => true, :unique_index => :name
  property :location, String, :required => true
  property :connected, Boolean, :required => true, :default => true
  property :connection_down_start, DateTime
  property :connection_down_end, DateTime

  #todo - Incluir updated_at e recarregar base de dados
  property :updated_at, DateTime
  property :ip_range, String, :required => true

  has n, :connection_histories
  belongs_to :user

  validates_presence_of :room_name, :location, :user
  validates_uniqueness_of :room_name, :location, :ip_range
  validates_with_method :check_off_time

  #validations

  def check_off_time
    status = true
    unless self.connected
      if self.connection_down_end && self.connection_down_start
        if self.connection_down_end < self.connection_down_start
          status = [false,'Connected é falso, logo o horário de religamento da internet deve ser maior que o horário de desligamento']
        end
      else
        status = [false, 'Connection down end ou Connection down start são nulos, porém Connected é falso']
      end
    end

    status
  end


  def on
    self.connected = true
    self.connection_down_start = nil
    self.connection_down_end = nil
  end

  def off(end_time, user)
    self.connected = false
    self.connection_down_start = DateTime.now()
    self.connection_down_end = end_time
    self.user = user
  end

  def save

    ch=ConnectionHistory.new
    ch.connected = self.connected
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
          ch.connected ? 'on' : 'off'                         #status da internet
      ]
    end
  end

  def self.list
        # numero: 5,
        # sala: 260,
        # internet: true,
        # by: nil,
        # start_time: nil,
        # end_time: nil
    connections = Connection.all.map.with_index(0) do |c,index|
      date = DateTime.now.strftime("%d/%m/%Y")
      start_time_p = (c.connection_down_start ? c.connection_down_start.strftime("%H:%M") : 'n/a')
      end_time_p = (c.connection_down_end ? c.connection_down_end.strftime("%H:%M") : 'n/a')

      hash = {
          id: c.id,
          order: index,
          room_name: c.room_name,
          location: c.location,
          internet: c.connected,
          by: c.user.username,
          date: date,
          start_time: start_time_p,
          end_time: end_time_p
      }
      index=index + 1
      hash

    end
    connections
  end

  def self.sync(connections_hashs = {})
    data = Connection.format_to_squid
    #TODO - Passar para variável de ambiente
    squid_key = '1234'
    RestClient.post('localhost:9898/sync', :params =>{:data => data.to_json, :squid_key => squid_key})
  end


  def self.format_to_squid
    connections = Connection.all.map do |c|
      start_time_p = (c.connection_down_start ? c.connection_down_start.strftime("%d/%m/%y %H:%M:%S") : 'n/a')
      end_time_p = (c.connection_down_end ? c.connection_down_end.strftime("%d/%m/%y %H:%M:%S") : 'n/a')

      hash = {
          room_name: c.room_name,
          connected: c.connected,
          ip_range: c.ip_range,
          down_time: start_time_p,
          up_time: end_time_p,
          updated_at: c.updated_at.strftime("%d/%m/%y %H:%M:%S")
      }
      hash
    end
    connections
  end

  def self.squid_sync
    data = Connection.format_to_squid
    #TODO - Passar para variável de ambiente
    squid_key = '1234'
    RestClient.post('192.168.1.20:9898/squid_reconfigure', :params =>{:labs => data.to_json, :squid_key => squid_key})
  end
end

#DataMapper.finalize