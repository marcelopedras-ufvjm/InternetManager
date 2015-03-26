require 'dm-core'
require 'dm-migrations'
require 'active_support/core_ext/numeric/time'
require 'dm-validations'
require 'attr_encrypted'
require 'attr_encrypted/adapters/data_mapper'
require 'json'
require_relative '../lib/ldapsearch.rb'

#DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
#DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/production.db")

class User

  include DataMapper::Resource

  INTERVAL_TIME = 15.minutes
  TOKEN_SIZE = 50

  property :id, Serial
  property :username, String, :required => true
  property :password, String
  property :encrypted_password, String
  property :token, Text, :required => true,  :writer => :private
  property :end_live, DateTime, :required => true,  :writer => :private

  attr_encrypted :password, :key=>'fpDZ9XxpQXgyJju2kqbx5cB1rQS7N2lOJcOjZ2yDt9ofOBgUvcHrnNVyBNqzOujkLALlc8gTjZzzbrjMnX2UHgUX9eq9jcUpuXYn297OlkzYaxlHQWcqjCbKKIuGHWLvf-FQgA', :encode => true
  ldap_params = {
      base: 'dc=ict,dc=ufvjm',
      host: '192.168.1.17',
      port: 389,
      user_base: 'ou=Users,dc=ict,dc=ufvjm',
      group_base: 'ou=Groups,dc=ict,dc=ufvjm'
  }

  LdapSearch.ldap_params = ldap_params

  has n, :connections
  has n, :connection_histories


  validates_presence_of :username, :encrypted_password, :token, :end_live
  validates_uniqueness_of :username, :token



  def self.sign(user, password)
    group = %w'ICT_admins_labs ICT_professores'

    if LdapSearch.instance.authenticate(user, password,group)
      u = self.first(:username => user, :encrypted_password => User.encrypt(:password, password))
      unless u
          u = User.new
          u.username = user
      end
      u.password = password
      u.create_token
      u.refresh_time_live
      u.save
      return u
    end
  end

  def self.authenticate_by_token(p_token)
    u = self.first(:token => p_token)
    if u && !u.expired?
      u.refresh_time_live
      u.save
      return u
    end
  end

  def authenticate_by_ldap
    LdapSearch.instance.authenticate(self.username, self.password)
  end

  def expire_token_time
    self.end_live = (DateTime.now.to_time - 1.minute).to_datetime
  end

  def expired?
    if self.end_live
      self.end_live < DateTime.now
    end
  end

  def is_valid_token?(token)
    unless expired?
      return self.token == token
    end
    false
  end

  def create_token
    self.token=SecureRandom.urlsafe_base64(TOKEN_SIZE)
    #refresh_time_live
  end

  def refresh_token_if_expired
    if expired?
      create_token
      refresh_time_live
    end
  end

  def refresh_time_live
    self.end_live = (DateTime.now.to_time + INTERVAL_TIME).to_datetime
  end

  def to_json
    {
        username: self.username,
        token: self.token,
        end_live: self.end_live

    }.to_json
  end


end

#DataMapper.finalize