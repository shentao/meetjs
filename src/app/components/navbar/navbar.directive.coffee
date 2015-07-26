angular.module "meetjs"
.directive 'acmeNavbar', ->

  NavbarController = ->
    vm = this
    # "vm.creation" is avaible by directive option "bindToController: true"
    return

  directive =
    restrict: 'E'
    templateUrl: 'app/components/navbar/navbar.html'
    scope: false
    controller: NavbarController
    controllerAs: 'vm'
    bindToController: true
