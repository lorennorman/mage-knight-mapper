MageKnight =
  bootstrap: ->
    @terrainMesh ?= do ->
      stage = new createjs.Stage("demo")
      stage.enableMouseOver()

      terrainMesh = new MageKnight.TerrainMesh()
      terrainMeshView = new MageKnight.TerrainMeshView(terrainMesh)
      stage.addChild(terrainMeshView)

      controlPanel = new MageKnight.ControlPanelView(terrainMeshView)
      stage.addChild(controlPanel)

      createjs.Ticker.useRAF = true
      createjs.Ticker.setFPS(5)
      createjs.Ticker.addEventListener "tick", -> stage.update()

      # return the terrain mesh
      terrainMesh

  startWithMegaTile: (tiles) ->
    terrainMesh = @bootstrap()

    middleTile = MageKnight.Tile.fromNames(tiles[1][1][0], tiles[1][1][1])
    terrainMesh.addFirstTile(middleTile)
    terrainMesh.addTile([0], [tiles[0][1][0], tiles[0][1][1]])
    terrainMesh.addTile([1], [tiles[1][2][0], tiles[1][2][1]])
    terrainMesh.addTile([2], [tiles[2][1][0], tiles[2][1][1]])
    terrainMesh.addTile([3], [tiles[2][0][0], tiles[2][0][1]])
    terrainMesh.addTile([4], [tiles[1][0][0], tiles[1][0][1]])
    terrainMesh.addTile([5], [tiles[0][0][0], tiles[0][0][1]])

window.MageKnight = MageKnight