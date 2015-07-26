angular.module "meetjs"
.controller "MainController", ($scope, $firebaseArray) ->

  @playerList = $firebaseArray(new Firebase("https://meetjswroclaw.firebaseio.com/players"))

  @isPlayer = false
  @isSpectator = false
  @playerName = ''
  refId = undefined

  @resetGame = =>
    for i in @playerList
      @playerList.$remove(i)

  @login = =>
    newPlayer =
      playerName: @playerName
      position:
        x: 0
        y: 0

    @playerList.$add( newPlayer )
      .then (ref) =>
        @playerId = ref.key()
        refId = @playerList.$indexFor(@playerId)
        @isPlayer = true

        startGame()



  updatePositions = (x, y) =>
    @playerList[refId].position.x = x
    @playerList[refId].position.y = y
    @playerList.$save(refId)

  startGame = ->
    euler = undefined
    tilt =
      x: 0
      y: 0

    ftPromise = new FULLTILT.getDeviceOrientation({ 'type': 'world' })
    ftPromise
      .then (orientationControl) ->
        orientationControl.listen ->
          # if (euler.beta > 85 && euler.beta < 95)
            # return

          euler = orientationControl.getScreenAdjustedEuler()

          tilt.x = tilt.x + euler.gamma * 0.1

          tilt.y = tilt.y + euler.beta * 0.1

          $scope.$apply ->
            updatePositions(tilt.x, tilt.y)

    .catch (message) ->
      console.error message


  return this
