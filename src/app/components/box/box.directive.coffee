angular.module "meetjs"
.directive 'box', ->

  directive =
    restrict: 'E'
    templateUrl: 'app/components/box/box.html'
    replace: true
    scope:
      player: "=player"

    link: (scope, element, attrs, ctrls) ->

      aliveStatus = undefined
      attackStatus = undefined

      moveObjects = scope.$watch (player) ->
        if !player.player.alive
          element.addClass('dead')
          moveObjects()

        else
          transformBox()

        if player.player.attack && attackStatus isnt true
          attackStatus = true
          element.addClass('attacking')

          window.setTimeout(->
            element.removeClass('attacking')
            attackStatus = false
          , 400)

      transformBox = ->
        element[0].style['transform'] = 'translate3d(' + scope.player.position.x * 5 + 'px, ' + scope.player.position.y * 5 + 'px, 0)'

      transformBox()
