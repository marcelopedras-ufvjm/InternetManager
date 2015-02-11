require 'rubygems'
require 'net/ldap'
require 'pp'

#server_ip_address = '192.168.1.17'
# ldap = Net::LDAP.new :host => server_ip_address,
#                     :port => 389,
#                      :auth => {
#                          :method => :simple,
#                          :username => "cn=admin,dc=ict,dc=ufvjm",
#                          :password => "meu_password"
#                      }
#
# filter = Net::LDAP::Filter.eq( "cn", "carol" )
# treebase = "dc=ict,dc=ufvjm"
#
# ldap.search( :base => treebase, :filter => filter ) do |entry|
#   puts "DN: #{entry.dn}"
#   entry.each do |attribute, values|
#     puts "   #{attribute}:"
#     values.each do |value|
#       puts "      --->#{value}"
#     end
#   end
# end
#
# p ldap.get_operation_result


class LdapSearch

  def initialize

    @base = 'ou=Users,dc=ict,dc=ufvjm'
    @host = '192.168.1.17'
    @port = 389
    @auth = {
        :method => :simple,
        :username => "cn=admin,dc=ict,dc=ufvjm",
        :password => "meu_password"
    }
    @ldap = Net::LDAP.new :host => @host,
                          :port => @port,
                          :auth => @auth
  end

  def group_filter(group)
    Net::LDAP::Filter.eq("memberOf", "cn=#{group},ou=Groups,dc=ict,dc=ufvjm") if group
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
    @ldap.search(:base => @base, :filter => filter) do |entry|
      puts "DN: #{entry.dn}"
      entry.each do |attribute, values|
        puts "   #{attribute}:"
        values.each do |value|
          puts "      --->#{value}"
        end
      end
    end
    #p @ldap.get_operation_result
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
        base: @base,
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

ldap = LdapSearch.new

ldap.authenticate('marcelopedras','meu_password','ICT_admins_labs')
#ldap.ldap_search_by_user('carol')
#ldap.search_by_group('ICT_admin_labs')