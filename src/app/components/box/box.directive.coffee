angular.module "meetjs"
.directive 'box', ->


  BoxController = ($scope, $firebaseObject, $interval) ->
    box = this

    $scope.changeToSuper = ->
      $scope.data.position.x = 50
      $scope.data.position.y = 100
      $scope.data.$save()

    return


  directive =
    restrict: 'E'
    templateUrl: 'app/components/box/box.html'
    replace: true
    scope:
      player: "=player"
    controller: BoxController
    controllerAs: 'box'

    link: (scope, element, attrs, ctrls) ->

      screenWidth = window.innerWidth
      screenHeight = window.innerHeight

      scope.$watch (player) ->
        transformBox()

      transformBox = ->
        element[0].style['transform'] = 'translate3d(' + scope.player.position.x * 5 + 'px, ' + scope.player.position.y * 5 + 'px, 0)'

