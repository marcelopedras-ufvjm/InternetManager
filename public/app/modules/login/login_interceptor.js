/**
 * Created by marcelo on 25/02/15.
 */
mainApp.factory('AuthInterceptor',
    ['$q','$location','loginStatus', function($q, $location, loginStatus) {
        return {
            request: function(config) {
                config.headers['AUTH_BY_TOKEN'] = localStorage['token'];
                return config;
            },

            responseError: function(responseRejection) {
                loginStatus.setAsLogout();
                loginStatus.logout();

                $location.path('/');
                return $q.reject(responseRejection);
            }
        };
    }])
    .config(['$httpProvider', function($httpProvider) {
        $httpProvider.interceptors.push('AuthInterceptor');
    }]);