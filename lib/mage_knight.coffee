Maps = new Lawnchair ->

MageKnight =
  newMap: ->
    tileStack = MageKnight.Util.promptForTileStack()
    mesh = new MageKnight.TerrainMesh(tileStack: tileStack)
    mesh.addTileGroup new MageKnight.HexCoordinate([]), MageKnight.TileStack.getStartGroup()
    @updateMesh(mesh)

  save: () ->
    throw "No map to save?" unless @terrainMesh?
    Maps.save(key: 'map', data: @terrainMesh.toObject())

  load: () ->
    Maps.get 'map', (map) =>
      if map?
        try
          newMesh = MageKnight.TerrainMesh.fromObject(map.data)
          @updateMesh(newMesh)
        catch e
          console.log "failed to load the map, starting a new one"
          @newMap()
      else
        @newMap()

  getStage: ->
    @stage ?= do ->
      stage = new createjs.Stage("demo")
      stage.enableMouseOver()

      createjs.Ticker.useRAF = true
      createjs.Ticker.setFPS(15)
      createjs.Ticker.addEventListener "tick", -> stage.update()

      stage

  updateMesh: (mesh) ->
    @clearMesh()
    @setMesh(mesh)

  clearMesh: () ->
    @terrainMesh = null
    @getStage().removeAllChildren()

  setMesh: (mesh) ->
    @terrainMesh = mesh
    @terrainMesh.addObserver => @save()
    terrainMeshView = new MageKnight.TerrainMeshView(mesh)

    getRandomCloud = ->
      cloudNum = Math.ceil(Math.random()*6)
      cloudFile = "#{MageKnight.Loader.filePath}clouds/cloud#{cloudNum}.png"
      cloud = new createjs.Bitmap(cloudFile)
      cloud.x = Math.random()*640 - 220
      cloud.y = Math.random()*480# - 140
      cloud.scaleX = cloud.scaleY = .33 + Math.random()/4
      cloud.alpha = .33 + Math.random()/4
      cloud.rotation = 315
      totalSpeed = .75 + Math.random()
      cloud._speedX = totalSpeed/2 #(.75 + Math.random())
      cloud._speedY = -totalSpeed/4 #-(.5 + Math.random())
      cloud

    clouds = (getRandomCloud() for i in [1..10])

    cloudTicker = ->
      for cloud in clouds
        do (cloud) ->
          if cloud.x > 860
            cloud.x = -220
          if cloud.y < -140
            cloud.y = 620

          cloud.x += cloud._speedX
          cloud.y += cloud._speedY

    setInterval ->
      cloudTicker()
    , 50

    camera = new MageKnight.Camera(terrainMeshView)
    cameraView = new MageKnight.CameraView(camera)
    newMeshButton = new MageKnight.Button("New", => @newMap() if confirm("Are you sure?"))
    controlPanel = new MageKnight.ControlPanelView(cameraView, newMeshButton)
    
    stage = @getStage()
    stage.addChild(terrainMeshView)
    stage.addChild(cloud) for cloud in clouds
    stage.addChild(controlPanel)


  bootstrap: ->
    @terrainMesh ?= do =>
      terrainMesh = new MageKnight.TerrainMesh()
      @setMesh(terrainMesh)

      terrainMesh

window.MageKnight = MageKnight
