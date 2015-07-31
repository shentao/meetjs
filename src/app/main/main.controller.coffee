angular.module "meetjs"
.controller "MainController", ($scope, $firebaseArray, $interval) ->

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
      alive: true
      position:
        x: 0
        y: 0

    @playerList.$add( newPlayer )
      .then (ref) =>
        @playerId = ref.key()
        refId = @playerList.$indexFor(@playerId)
        @isPlayer = true

        startGame()


  @checkIfHit = =>
    allPlayers = @playerList
    thisPlayer = @playerList[refId]

    if @playerList[refId].alive
      for player, index in allPlayers
        if index isnt refId
          if (thisPlayer.position.x >= player.position.x - 5) && (thisPlayer.position.x <= player.position.x + 5)
            if (thisPlayer.position.y >= player.position.y - 5) && (thisPlayer.position.y <= player.position.y + 5)
              @playerList[index].alive = false
              @playerList.$save(index)

  updatePositions = (x, y) =>
    @playerList[refId].position.x = x
    @playerList[refId].position.y = y
    @playerList.$save(refId)

  startGame = ->
    euler = undefined
    tilt =
      x: 0
      y: 0

    ftPromise = new FULLTILT.getDeviceOrientation()
    ftPromise
      .then (orientationControl) ->
        orientationControl.listen ->

          euler = orientationControl.getScreenAdjustedEuler()
          if (euler.beta > 85 && euler.beta < 95)
            return

          tilt.x = tilt.x + euler.gamma * 0.05

          tilt.y = tilt.y + euler.beta * 0.05

          if tilt.x > 60 then tilt.x = 60
          if tilt.x < -60 then tilt.x = -60

          if tilt.y > 60 then tilt.y = 60
          if tilt.y < -60 then tilt.y = -60

      .catch (message) ->
        console.error message

    update = $interval((->
      updatePositions(tilt.x, tilt.y)
      if @playerList[refId].alive is false
        update()
    ), 100)

  return this
