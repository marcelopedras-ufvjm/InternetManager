var mainApp = angular.module('mainApp',['ngRoute'])

    .config(['$routeProvider', function($routeProvider) {
        $routeProvider.when('/test', {
            templateUrl: '/app/views/login.html',
            controller: 'LoginController',
            controllerAs : 'myCtrl'

       });
    }]);