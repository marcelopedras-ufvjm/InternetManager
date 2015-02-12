require './ldapsearch.rb'

ldap = LdapSearch.new
#ldap.authenticate('marcelopedras','mozila79','ICT_admins_labs')
#ldap.search_by_user('carol')
ldap.search_by_group('ICT_admins_labs')