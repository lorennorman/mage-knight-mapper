class MageKnight.TerrainMeshView extends createjs.Container
  constructor: (@model) ->
    super()
    @x = @y = 200
    @scaleX = @scaleY = .5

    @tileViewFactory = new MageKnight.TileViewCache()

    @model.addObserver(@updateDisplayList)

  updateDisplayList: () =>
    @clearViews()
    @addTileViews()
    @addHintViews()

  clearViews: ->
    @removeAllChildren()

  addTileViews: ->
    for tile in @model.revealedTiles()
      do (tile) =>
        tileView = @tileViewFactory.findByModel(tile)
        @addChild(tileView)

  addHintViews: ->
    for location in @model.revealableLocations()
      do (location) =>
        hintView = MageKnight.HintView.fromHexordinate(location)
        hintView.onClick = =>
          @model.addTile(location.array, MageKnight.Tile.generateRandom())

        @addChild(hintView)
