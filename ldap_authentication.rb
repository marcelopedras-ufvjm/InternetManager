require 'rubygems'
require 'net/ldap'
require 'pp'

server_ip_address = '192.168.1.17'
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


class MyLdapSearch

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

    p @ldap.get_operation_result
  end
  def ldap_search_by_user(user)

    filter = Net::LDAP::Filter.eq("cn", user)
    search(filter)



  end

  def ldap_authenticate(user, password)


    result = @ldap.bind_as(
        base: @base,
        filter: "uid=#{user}",
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

  def search_by_group(group)
    filter =
        Net::LDAP::Filter.eq("objectclass","inetOrgPerson") &
        Net::LDAP::Filter.eq("memberOf", "cn=#{group},ou=Groups,dc=ict,dc=ufvjm")



    search(filter)

  end

end

ldap = MyLdapSearch.new
#ldap.ldap_authenticate('carol','meu_password')
#ldap.ldap_search_by_user('carol')
ldap.search_by_group('alunos')