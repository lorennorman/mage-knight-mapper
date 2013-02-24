Maps = new Lawnchair ->

MageKnight =
  newMap: ->
    mesh = new MageKnight.TerrainMesh()
    mesh.addTileGroup new MageKnight.HexCoordinate([]), MageKnight.TileSet.getStartGroup()
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

  startWithMegaTile: (tiles) ->
    terrainMesh = @bootstrap()

    middleTile = MageKnight.Tile.fromNames(tiles[1][1][0], tiles[1][1][1])
    terrainMesh.addFirstTile(middleTile)
    terrainMesh.easyAddTile([0], [tiles[0][1][0], tiles[0][1][1]])
    terrainMesh.easyAddTile([1], [tiles[1][2][0], tiles[1][2][1]])
    terrainMesh.easyAddTile([2], [tiles[2][1][0], tiles[2][1][1]])
    terrainMesh.easyAddTile([3], [tiles[2][0][0], tiles[2][0][1]])
    terrainMesh.easyAddTile([4], [tiles[1][0][0], tiles[1][0][1]])
    terrainMesh.easyAddTile([5], [tiles[0][0][0], tiles[0][0][1]])

window.MageKnight = MageKnight