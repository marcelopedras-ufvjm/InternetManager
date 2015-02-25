/**
 * Created by marcelo on 25/02/15.
 */

mainApp.service('loginStatus',[function(){
    var attributes = {
        logged: false
    };

    this.isLogged = function() {
        return attributes.logged;
    };

    this.login = function() {
        attributes.logged = true;
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
}]);