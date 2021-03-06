require 'rubygems'
require 'net/ldap'
require 'pp'
require 'singleton'

class LdapSearch
  include Singleton
  @@ldap_params = {}

  def self.ldap_params=(parameters)
    @@ldap_params = parameters
  end

  def initialize()
    p = {
      base: 'dc=ict,dc=ufvjm',
      host: "#{ENV['LDAP_HOST']}",
      port: 389,
      user_base: 'ou=Users,dc=ict,dc=ufvjm',
      group_base: 'ou=Groups,dc=ict,dc=ufvjm'
    }.merge(@@ldap_params)


    # @base = 'ou=Users,dc=ict,dc=ufvjm'
    # @host = '192.168.1.17'
    # @port = 389

    @base       = p[:base]
    @host       = p[:host]
    @port       = p[:port]
    @user_base  = p[:user_base]
    @group_base = p[:group_base]

    # @auth = {
    #     :method => :simple,
    #     :username => "cn=admin,dc=ict,dc=ufvjm",
    #     :password => "meu_password"
    #}
    @ldap = Net::LDAP.new :host => @host,
                          :port => @port #,
                          #:auth => @auth
  end

  def group_filter(group)
    if group.class == Array
      return group.map do |g|
        Net::LDAP::Filter.eq("memberOf", "cn=#{g},#{@group_base}")
      end.reduce do |g1,g2|
        g1 | g2
      end
    end

    Net::LDAP::Filter.eq("memberOf", "cn=#{group},#{@group_base}") if group
  end

  def person_filter
    Net::LDAP::Filter.eq("objectclass","inetOrgPerson")
  end

  def user_filter(user)
    Net::LDAP::Filter.eq("uid", user) & person_filter
  end

  def group_and_user_filter(user,group)
    g_filter = group_filter group
    u_filter = user_filter user

    g_filter & u_filter
  end



  def search(filter)
    result_set = Array.new
    @ldap.search(:base => @user_base, :filter => filter) do |entry|
      #puts "DN: #{entry.dn}"
      result = Hash.new
      entry.each do |attribute, values|
          #puts "   #{attribute}:"
          result[attribute] = Array.new
          if values.size > 1
            values.each do |value|
              #puts "      --->#{value}"
              result[attribute].push(value)
            end
          else
            result[attribute] = values.first
          end
      end
      result_set.push(result)
    end
    #p @ldap.get_operation_result
    result_set
  end

  def search_by_user(user,group = nil)

    if group
      filter = group_and_user_filter(user,group)
    else
      filter = user_filter(user)
    end

    search(filter)
  end

  def search_by_group(group)
    filter =
        person_filter &
            group_filter(group) &
            Net::LDAP::Filter.negate(user_filter('nobody'))

    search(filter)
  end

  def authenticate(user, password, group = nil)

    g_filter = group_filter group


    filter = user_filter user
    if g_filter
      filter = filter & g_filter
    end

    result = @ldap.bind_as(
        base: @user_base,
        filter: filter,
        password: password
    )

    if result
      puts "Authenticated #{result.first.dn}"
      #puts "Result: #{ldap.get_operation_result.code}"
      #puts "Message: #{ldap.get_operation_result.message}"
      puts @ldap.get_operation_result
      true
    else
      puts "Authentication FAILED."
      false
    end
  end
end



