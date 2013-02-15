MageKnight =
  bootstrap: ->
    @terrainMesh ?= do ->
      # make a stage
      stage = new createjs.Stage("demo")
      stage.x = 190
      stage.y = 180
      stage.scaleX = stage.scaleY = .35
      # stage.rotation = 180

      # make a terrain mesh
      terrainMesh = new MageKnight.TerrainMesh()
      tileViews = new MageKnight.TileViewCache()

      # bind the stage's view stack to the terrain mesh
      terrainMesh.observers.push ->
        stage.removeAllChildren()

        for tile in terrainMesh.tiles
          do (tile) ->
            # construct a graphical primitive to represent this tile
            tileView = tileViews.findByModel(tile)
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
    middleTile = MageKnight.Tile.fromNames(tiles[1][1][0], tiles[1][1][1])

    terrainMesh = @bootstrap()

    terrainMesh.addFirstTile(middleTile)
    terrainMesh.addTile([0], [tiles[0][1][0], tiles[0][1][1]])
    terrainMesh.addTile([1], [tiles[1][2][0], tiles[1][2][1]])
    terrainMesh.addTile([2], [tiles[2][1][0], tiles[2][1][1]])
    terrainMesh.addTile([3], [tiles[2][0][0], tiles[2][0][1]])
    terrainMesh.addTile([4], [tiles[1][0][0], tiles[1][0][1]])
    terrainMesh.addTile([5], [tiles[0][0][0], tiles[0][0][1]])

window.MageKnight = MageKnight