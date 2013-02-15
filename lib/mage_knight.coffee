MageKnight =
  bootstrap: ->
    @terrainMesh ?= do ->
      # make a stage
      stage = new createjs.Stage("demo")
      stage.x = 190
      stage.y = 180
      stage.scaleX = stage.scaleY = .15
      # stage.rotation = 180

      # make a terrain mesh
      terrainMesh = new MageKnight.TerrainMesh()

      # bind the stage's view stack to the terrain mesh
      terrainMesh.observers.push ->
        stage.removeAllChildren()

        for tile in terrainMesh.tiles
          do (tile) ->
            # construct a graphical primitive to represent this tile
            tileView = tile.getTileView()
            # hand it off to the drawing system
            stage.addChild(tileView)


        # ensure the drawing system is running
        stage.update()

        setTimeout ->
          stage.update()
        , 200

      # return the terrain mesh
      terrainMesh

  startWithMegaTile: (tiles) ->
    tile6 = MageKnight.Tile.fromNames(tiles[0][0][0], tiles[0][0][1])
    tile1 = MageKnight.Tile.fromNames(tiles[0][1][0], tiles[0][1][1])
    tile5 = MageKnight.Tile.fromNames(tiles[1][0][0], tiles[1][0][1])
    tile0 = MageKnight.Tile.fromNames(tiles[1][1][0], tiles[1][1][1]) # <- center
    tile2 = MageKnight.Tile.fromNames(tiles[1][2][0], tiles[1][2][1])
    tile4 = MageKnight.Tile.fromNames(tiles[2][0][0], tiles[2][0][1])
    tile3 = MageKnight.Tile.fromNames(tiles[2][1][0], tiles[2][1][1])

    terrainMesh = @bootstrap()

    terrainMesh.addFirstTile(tile0)
    terrainMesh.addNeighborTo(tile0, 0, tile1)
    terrainMesh.addNeighborTo(tile0, 1, tile2)
    terrainMesh.addNeighborTo(tile0, 2, tile3)
    terrainMesh.addNeighborTo(tile0, 3, tile4)
    terrainMesh.addNeighborTo(tile0, 4, tile5)
    terrainMesh.addNeighborTo(tile0, 5, tile6)

    terrainMesh.addNeighborTo(tile0, [0, 0], MageKnight.Tile.fromNames("forest"))
    terrainMesh.addNeighborTo(tile0, [0, 5], MageKnight.Tile.fromNames("mountain"))
    terrainMesh.addNeighborTo(tile0, [0, 0, 2], MageKnight.Tile.fromNames("forest", "fortress"))
    terrainMesh.addNeighborTo(tile0, [1, 1], MageKnight.Tile.fromNames("swamp"))
    terrainMesh.addNeighborTo(tile0, [1, 1, 1], MageKnight.Tile.fromNames("hill", "glade"))
    terrainMesh.addNeighborTo(tile0, [1, 1, 2], MageKnight.Tile.fromNames("grass", "monastery"))
    terrainMesh.addNeighborTo(tile0, [1, 2], MageKnight.Tile.fromNames("water"))
    terrainMesh.addNeighborTo(tile0, [1, 2, 2], MageKnight.Tile.fromNames("water"))
    terrainMesh.addNeighborTo(tile0, [1, 2, 3], MageKnight.Tile.fromNames("water"))
    terrainMesh.addNeighborTo(tile0, [2, 3], MageKnight.Tile.fromNames("water"))
    terrainMesh.addNeighborTo(tile0, [4, 3], MageKnight.Tile.fromNames("desert", "magetower"))

window.MageKnight = MageKnight