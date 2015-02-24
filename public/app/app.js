var mainApp = angular.module('mainApp',['ngRoute'])

    .config(['$routeProvider', function($routeProvider) {
        $routeProvider
            .when('/', {
                templateUrl: '/app/views/login.html',
                controller: 'LoginController',
                controllerAs : 'myCtrl'

            })
            .when('/labs',{
                templateUrl: '/app/views/list_labs.html',
                controller: 'InternetLabsController',
                controllerAs : 'myCtrl'
            });
    }])
    .config(['$httpProvider', function($httpProvider) {
// Every POST data becomes jQuery style
        $httpProvider.defaults.transformRequest.push(
            function(data) {
                var requestStr;
                if (data) {
                    data = JSON.parse(data);
                    for (var key in data) {
                        if (requestStr) {
                            requestStr += '&' + key + '=' + data[key];
                        } else {
                            requestStr = key + '=' + data[key];
                        }
                    }
                }
                return requestStr;
            });
// Set the content type to be FORM type for all post requests
// This does not add it for GET requests.
        $httpProvider.defaults.headers.post['Content-Type'] =
            'application/x-www-form-urlencoded';
    }]
);