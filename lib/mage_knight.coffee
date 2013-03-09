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
    @terrainMeshView = new MageKnight.TerrainMeshView(mesh)

    clouds = (MageKnight.Cloud.random() for i in [1..8])
    camera = new MageKnight.Camera(@terrainMeshView)
    cameraView = new MageKnight.CameraView(camera)
    controlPanel = new MageKnight.ControlPanelView(cameraView)

    stage = @getStage()
    stage.addChild(@terrainMeshView)
    stage.addChild(cloud) for cloud in clouds
    stage.addChild(controlPanel)

  toggleMove: ->
    MageKnight.ViewSettings.showMoveScore = !MageKnight.ViewSettings.showMoveScore
    @terrainMeshView.updateDisplayList()

MageKnight.ViewSettings =
  showMoveScore: false

window.MageKnight = MageKnight
