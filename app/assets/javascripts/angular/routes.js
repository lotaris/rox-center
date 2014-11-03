angular.module('rox.routes', [ 'ui.router' ])

  .config(['$stateProvider', function($stateProvider) {

    $stateProvider

      .state('std', {
        abstract: true,
        templateUrl: '/templates/main.html'
      })

      .state('std.home', {
        url: '^/',
        views: {
          'content@std': {
            templateUrl: '/templates/home.html'
          }
        }
      })

      .state('std.projects', {
        url: '/projects',
        views: {
          'content@std': {
            templateUrl: '/templates/projects.html'
          }
        }
      })
      
    ;

  }])

;