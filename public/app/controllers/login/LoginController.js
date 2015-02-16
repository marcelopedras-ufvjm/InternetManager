/**
 * Created by marcelo on 16/02/15.
 */

mainApp.controller('LoginController',['$http',function($http){
    console.log('logincontroller criado')
    var self = this;

    self.attributes = {
        login: '',
        password: ''
    };

    self.sign = function() {
        $http.get('/login/sign/'+self.attributes.login + '/' +self.attributes.password).then(function(response){
            console.log(response.data);
        }, function(errResponse){
            console.log('Houve um erro');
        });
        //console.log(self.attributes.login + ' ' + self.attributes.password)
    }





}]);