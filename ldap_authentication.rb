require 'rubygems'
require 'net/ldap'

server_ip_address = '192.168.1.17'
#ldap = Net::LDAP.new :host => server_ip_address,
#                     :port => 389,
                     # :auth => {
                     #     :method => :simple,
                     #     :username => "cn=admin,dc=ict,dc=ufvjm",
                     #     :password => "mozila79"
                     # }
#
# filter = Net::LDAP::Filter.eq( "cn", "carol" )
# treebase = "dc=ict,dc=ufvjm"

# ldap.search( :base => treebase, :filter => filter ) do |entry|
#   puts "DN: #{entry.dn}"
#   entry.each do |attribute, values|
#     puts "   #{attribute}:"
#     values.each do |value|
#       puts "      --->#{value}"
#     end
#   end
# end

# p ldap.get_operation_result




port = 389


def autentica(user, password)
  server_ip_address = '192.168.1.17'
treebase = 'cn=Users,dn=ict,dn=ufvjm'
  port=389
Net::LDAP.new :host => server_ip_address,
              :port => port,
              :base => treebase,
              :auth => { :username => user,
                         :password => password,
                         :method => :simple }

end

result= autentica('carolfdas','mozila79')
p result.auth('carol', 'mozila79')