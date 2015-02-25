/**
 * Created by marcelo on 20/02/15.
 */
mainApp.service('loginSession',['$http','loginStatus', function($http,loginStatus){

    var self = this;
    var attributes = {
        user: '',
        authenticated: false,
        token: ''
    };
    
    var setAsLogout = function() {
        loginStatus.setAsLogout();
    };
    
    var setAsLogin = function(user, token) {
        loginStatus.setAsLogin(user, token);
    };
    
    
    this.sign = function(pUser, pPassword, pGroup) {

        return $http.post('/login/sign',{user: pUser, password: pPassword, group: pGroup}).then(function(response){
            setAsLogin(response.data.user, response.data.token);
            loginStatus.login();
            return response.data

        }, function(errResponse){
            setAsLogout();
            loginStatus.logout();
            return errResponse.data
        });
    };

    this.authenticate_by_token = function() {

        return $http.post('/login/authenticate_by_token',{token: self.getToken()}).then(function(response){

            setAsLogin(response.data.user, response.data.token);
            loginStatus.login();
            return response.data

        }, function(errResponse){
            setAsLogout();
            loginStatus.logout();
            return errResponse.data
        });
    };

    this.logout = function() {

        return $http.post('/login/logout',{token: self.getToken()}).then(function(response){
            setAsLogout()
            loginStatus.logout();

            return response.data

        }, function(errResponse){
            setAsLogout();
            return errResponse.data
        });
    };

    this.isLoggedIn = function() {
        return  loginStatus.isLogged();
    };

    this.getUser = function() {
        return localStorage['user'];
    };

    this.getToken = function() {
        return localStorage['token'];
    };
}]);