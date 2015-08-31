angular.module "meetjs"
.controller "MainController", ($scope, $firebaseArray, $interval, $timeout) ->

  @playerList = $firebaseArray(new Firebase("https://meetjswroclaw.firebaseio.com/players"))
  @killedList = $firebaseArray(new Firebase("https://meetjswroclaw.firebaseio.com/killed"))

  @isPlayer = false
  @isSpectator = false
  @playerIsAlive = true
  @playerName = ''
  @ready = true
  @playerId = undefined
  player = undefined
  refId = undefined

  @resetGame = =>
    for i in @playerList
      @playerList.$remove(i)
    for i in @killedList
      @killedList.$remove(i)

  @login = =>
    newPlayer =
      playerName: @playerName
      alive: true
      kills: 0
      position:
        x: 0
        y: 0

    @playerList.$add( newPlayer )
      .then (ref) =>
        player = ref
        @playerId = ref.key()
        refId = @playerList.$indexFor(@playerId)
        @id = @playerList.$indexFor(@playerId)
        @isPlayer = true

        startGame()

  @spectate = =>
    @isSpectator = true

  @checkIfHit = =>
    allPlayers = @playerList
    thisPlayer = @playerList[refId]

    if @playerIsAlive and @ready
      @ready = false
      if @playerList[refId].alive is true
        @playerList[refId].attack = true
        @playerList.$save(refId)
        for player, index in allPlayers
          if index isnt refId
            if (thisPlayer.position.x >= player.position.x - 15) && (thisPlayer.position.x <= player.position.x + 15)
              if (thisPlayer.position.y >= player.position.y - 15) && (thisPlayer.position.y <= player.position.y + 15)
                if player.alive is true
                  @playerList[index].alive = false
                  @playerList[refId].kills++
                  @killedList.$add(index)
                  @playerList.$save(index)
      else
        @playerIsAlive = false

      $timeout =>
        @playerList[refId].attack = false
        @playerList.$save(refId)
      , 300

      $timeout =>
        @ready = true
      , 2000

  updatePositions = (x, y) =>
    @playerList[refId].position.x = x
    @playerList[refId].position.y = y
    if @playerIsAlive
      @playerList.$save(refId).position

  startGame = =>
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

    update = $interval((=>
      if alive()
        updatePositions(tilt.x, tilt.y)
      else
        @playerList[refId].alive = false
        @playerList.$save(refId)
        @playerIsAlive = false
        update()
    ), 100)

    alive = =>
      for killedPlayer in @killedList
        return false if refId is killedPlayer.$value
      return true

  return this
