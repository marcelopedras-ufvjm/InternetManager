require './lib/ldapsearch'

ldap = LdapSearch.new
#ldap.authenticate('marcelopedras','meu_password','ICT_admins_labs')
#ldap.search_by_user('carol')
ldap.search_by_group('ICT_admins_labs')