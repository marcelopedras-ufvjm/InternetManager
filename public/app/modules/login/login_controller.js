/**
 * Created by marcelo on 16/02/15.
 */

mainApp.controller('LoginController',['$http','$location','loginSession',function($http,$location,loginSession){
    console.log('logincontroller criado');
    var self = this;
    self.partial = '/app/views/partials/_show_internet_status.html'
    self.logout_path = function() {
        var path = '/app/views/logout.html';
        if(loginSession.isLoggedIn()) {
            return path;
        } else {
            return '';
        }
    };
    self.attributes = {
        login: '',
        password: ''
    };

    self.sign = function() {

        loginSession.sign(self.attributes.login,self.attributes.password).then(function(response){
            console.log(response)
            $location.path('/labs');
        }, function(errResponse){
            console.log(errResponse.data)
        });
    };

    self.authenticate_by_token = function() {
        loginSession.authenticate_by_token().then(function(response){
            console.log(response)
        }, function(errResponse){
            console.log(errResponse.data)
        });
    };

    self.logout = function() {
        loginSession.logout().then(function(response){
            console.log(response)
            $location.path('/');
        }, function(errResponse){
            console.log(errResponse.data)
        });
    };
}]);