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
      createjs.Ticker.setFPS(5)
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
    camera = new MageKnight.Camera(terrainMeshView)
    cameraView = new MageKnight.CameraView(camera)
    newMeshButton = new MageKnight.Button("New", => @newMap() if confirm("Are you sure?"))
    controlPanel = new MageKnight.ControlPanelView(cameraView, newMeshButton)
    
    @getStage().addChild(terrainMeshView, controlPanel)

  bootstrap: ->
    @terrainMesh ?= do =>
      terrainMesh = new MageKnight.TerrainMesh()
      @setMesh(terrainMesh)

      terrainMesh

window.MageKnight = MageKnight