/**
 * Created by marcelo on 28/02/15.
 */
mainApp.service('connectionManager',['$http','loginStatus', function($http,loginStatus){

    var self = this;
    var attributes = {
        connections: [],
        initialized: false
    };

    self.initConnections = function() {
        return $http.get('/connection/list').then(function(response){
            attributes.connections = response.data;
            attributes.initialized = true;
            return response.data;
        }, function(error){});
    };


    self.getConnections = function() {
        return attributes.connections;
    };

    self.setConnection = function(c) {
        return $http.post('/connection/set',
            {
                id: c.id,
                internet: c.internet,
                start_time: c.start_time,
                end_time: c.end_time,
                username: c.username
            }).then(function(response){
                return response.data;
        }, function(error){});
    }

}]);