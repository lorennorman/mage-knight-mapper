class MageKnight.TerrainMeshView extends createjs.Container
  constructor: (@model) ->
    super()
    @x = 140
    @y = 400
    @rotation = 40
    @scaleX = .5
    @scaleY = .5

    @tileViewFactory = new MageKnight.TileViewCache()

    @model.addObserver(@updateDisplayList)

  updateDisplayList: () =>
    @clearViews()
    @addHintViews()
    @addTileViews()

  clearViews: ->
    @removeAllChildren()

  addTileViews: ->
    for tile in @model.revealedTiles()
      do (tile) =>
        tileView = @tileViewFactory.findByModel(tile)
        tileView.updateByModel(tile)
        @addChild(tileView)

  addHintViews: ->
    for location in @model.revealableLocations()
      do (location) =>
        hintView = MageKnight.HintView.fromHexordinate(location)
        hintView.onClick = =>
          @model.addNextTileGroupAt(location) if confirm("Reveal Tile?")

        @addChild(hintView)
