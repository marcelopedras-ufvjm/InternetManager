/**
 * Created by marcelo on 25/02/15.
 */

mainApp.service('loginStatus',[function(){
    var attributes = {
        logged: false,
        login_attempts: 0
    };

    this.isLogged = function() {
        return attributes.logged;
    };

    this.login = function() {
        attributes.logged = true;
        attributes.login_attempts = 0
    };

    this.logout = function() {
        attributes.logged = false;
    };

    this.setAsLogout = function() {
        localStorage['token'] = '';
        localStorage['authenticated'] = false;
        localStorage['user'] = '';
    };

    this.setAsLogin = function(user, token) {
        localStorage['token'] = token;
        localStorage['authenticated'] = true;
        localStorage['user'] = user;
    };

    this.increase_login_attemps = function(){
        ++attributes.login_attempts;
    };

    this.login_attemps = function(){
        return attributes.login_attempts
    };
}]);