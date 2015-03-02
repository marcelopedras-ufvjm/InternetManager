/**
 * Created by marcelo on 16/02/15.
 */

mainApp.controller('LoginController',['$http','$location','loginSession',function($http,$location,loginSession){
    var self = this;
    self.partial = '/app/views/partials/_show_internet_status.html';

    self.attributes = {
        login: '',
        password: ''
    };



    self.logout_path = function() {
        var path = '/app/views/logout.html';
        if(loginSession.isLoggedIn()) {
            return path;
        } else {
            return '';
        }
    };

    self.login_path = function() {
        var path = '/app/views/login.html';
        if(!loginSession.isLoggedIn()) {
            return path;
        } else {
            return '';
        }
    };

    self.sign = function() {
        loginSession.sign(self.attributes.login,self.attributes.password).then(function(response){
            //$location.path('/labs');
        }, function(errResponse){
            console.log(errResponse.data)
        });
    };

    self.authenticate_by_token = function() {
        loginSession.authenticate_by_token().then(function(response){
            console.log(response);
        }, function(errResponse){
        });
    };

    self.logout = function() {
        loginSession.logout().then(function(response){
            self.attributes.password = '';
            $location.path('/');
        }, function(errResponse){
        });
    };

    self.getUser = function() {
        return loginSession.getUser();
    };

    self.authenticate_by_token();
}]);