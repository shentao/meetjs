angular.module "meetjs"
.directive 'acmeNavbar', ->

  directive =
    restrict: 'E'
    templateUrl: 'app/components/navbar/navbar.html'
    scope: false
