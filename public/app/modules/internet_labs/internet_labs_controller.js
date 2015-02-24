/**
 * Created by marcelo on 17/02/15.
 */
mainApp.controller('InternetLabsController',['$http','$location','loginSession',function($http,$location,loginSession){
    console.log('InternetLabsController criado')
    var self = this;

    self.labs = [];

    self.editable = function() {
        if(loginSession.isLoggedIn()) {
            self.partial = "/app/views/partials/_on_off_internet.html";
        } else {
            self.partial = "/app/views/partials/_show_internet_status.html";
        }

        return self.partial;
    };

    var retrieveLab = function(lab) {
        return self.labs[lab-1];
    };


    self.markAsOn = function(lab) {
        var status = retrieveLab(lab).internet;
        return {
            'btn-success': status,
            'active': status

        }
    };

    self.markAsOff = function(lab) {
        var status = retrieveLab(lab).internet;
        return {
            'btn-danger': !status,
            'active': !status
        }
    };

    self.turnOn = function(lab) {
        var l = retrieveLab(lab);
        l.internet = true;
        console.log(retrieveLab(lab).internet);
    };

    self.turnOff = function(lab) {
        var l = retrieveLab(lab);
        l.internet = false;
        console.log(retrieveLab(lab).internet);
    };

    $http.get('/data').then(function(response){
        self.labs = response.data;
    }, function(error){});

}]);