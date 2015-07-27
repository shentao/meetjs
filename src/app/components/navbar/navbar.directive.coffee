angular.module "meetjs"
.directive 'acmeNavbar', ->

  NavbarController = ->
    vm = this

    return

  directive =
    restrict: 'E'
    templateUrl: 'app/components/navbar/navbar.html'
    scope: false
    controller: NavbarController
    controllerAs: 'vm'
    bindToController: true
