class MageKnight.TerrainMeshView extends createjs.Container
  constructor: (@model) ->
    super()
    @x = 50
    @y = 400
    @scaleX = .275
    @scaleY = .26

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
        hintView.onClick = => @model.addNextTileGroupAt(location)

        @addChild(hintView)
