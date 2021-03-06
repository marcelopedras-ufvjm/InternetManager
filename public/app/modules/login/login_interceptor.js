/**
 * Created by marcelo on 25/02/15.
 */
mainApp.factory('AuthInterceptor',
    ['$q','$location','loginStatus', function($q, $location, loginStatus) {
        return {
            request: function(config) {
                config.headers['AUTH_BY_TOKEN'] = sessionStorage['token'];
                return config;
            },

            responseError: function(responseRejection) {
                //TODO - Melhorar o comportamento para que seja possível voltar a lista dos estados originais dos laboratórios em caso de falha
                if(responseRejection.status == 401) {
                    loginStatus.setAsLogout();
                    loginStatus.logout();
                    $location.path('/');
                }
                return $q.reject(responseRejection);
            }
        };
    }])
    .config(['$httpProvider', function($httpProvider) {
        $httpProvider.interceptors.push('AuthInterceptor');
    }]);