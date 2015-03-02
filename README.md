# InternetManager
Esse aplicativo permite bloquear a conexão da internet por meio do squid3. Para isso usa autenticação por ldap a fim de verificar se o usuário tem permissão para mudar o status da conexão do laboratório. Isso é útil para aplicação de provas sem consulta ou para evitar distrações desnecessárias durante a aula.


Algumas das tecnologias utilizadas para isso foram:

ruby 2.2
gens:
  sinatra
  datamapper
  net/ldap

angulasjs
bootstrap

Pacotes linux:
  open-ldap
  squid3
