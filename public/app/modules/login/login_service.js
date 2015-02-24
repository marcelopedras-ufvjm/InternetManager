/**
 * Created by marcelo on 20/02/15.
 */
mainApp.service('loginSession',['$http', function($http){
    var attributes = {
        token: '',
        authenticate: false

    };

    this.sign = function(pUser, pPassword, pGroup) {

        return $http.post('/login/sign',{user: pUser, password: pPassword, group: pGroup}).then(function(response){
            //console.log(response.data);
            attributes.token = response.data.token;
            attributes.authenticate = true
            return response.data

        }, function(errResponse){
            //console.log(errResponse.data);
            //console.log('Houve um erro')
            attributes.authenticate = false;
            attributes.token = '';

            return errResponse.data
        });
    };

    this.authenticate_by_token = function() {
        return $http.post('/login/authenticate_by_token',{token: attributes.token}).then(function(response){
            //console.log(response);
            return response.data

        }, function(errResponse){
            //console.log(errResponse);
            //console.log('Houve um erro')
            return errResponse.data
        });
    };

    this.logout = function() {
        return $http.post('/login/logout',{token: attributes.token}).then(function(response){
            //console.log(response.data);
            attributes.token='';
            attributes.authenticate = false;
            return response.data

        }, function(errResponse){
            //console.log(errResponse);
            //console.log('Houve um erro')
            attributes.token='';
            attributes.authenticate = false;
            return errResponse.data
        });
    };

    this.isLoggedIn = function() {
        return attributes.authenticate;
    }
}]);