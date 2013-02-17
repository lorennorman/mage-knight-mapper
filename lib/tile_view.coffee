TileView =
  terrainColorMap:
    grass: "green"
    desert: "yellow"
    mountain: "darkblue"
    water: "lightblue"
    hill: "brown"
    rock: "darkbrown"
    swamp: "darkgreen"

  terrainFileMap:
    grass: "grass"
    desert: "desert"
    forest: "forest"
    hill: "hill"
    mountain: "mountain"
    water: "water"
    swamp: "swamp"

  featureColorMap:
    orcs: "green"
    draconum: "red"
    keep: "lightgray"
    magetower: "purple"
    dungeon: "lightbrown"
    tomb: "lightbrown"
    monsterden: "darkbrown"
    spawninggrounds: "darkbrown"
    village: "orange"
    monastery: "orange"
    city: "white"
    ruins: "yellow"
    mines: "brown"
    glade: "violet"
    portal: "pink"

  featureFileMap:
    keep: "keep"
    portal: "portal"
    monastery: "monastery"
    orcs: "orcs"
    village: "village"

  getTerrainView: (terrain) ->
    if @terrainFileMap[terrain]?
      terrainView = new createjs.Bitmap("terrain/#{@terrainFileMap[terrain]}.png")

      if terrain is "grass" or terrain is "hill"
        terrainView.x = terrainView.y = 0
        terrainView.scaleX = terrainView.scaleY = 1/.15
    else
      terrainView = new createjs.Shape()
      terrainView.graphics.beginFill(@terrainColorMap[terrain]).drawCircle(118, 138, 120)

    terrainView

  getFeatureView: (feature) ->
    if @featureFileMap[feature]?
      featureView = new createjs.Bitmap("feature/#{@featureFileMap[feature]}.png")
      featureView.x = 46
      featureView.y = 56

      if feature is "keep" or feature is "village"
        featureView.x = featureView.y = 0
        featureView.scaleX = featureView.scaleY = 1/.15
    else
      featureView = new createjs.Shape()
      featureView.graphics.beginFill(@featureColorMap[feature]).drawCircle(115, 137, 40)

    featureView

  fromModel: (model) ->
    terrainView = @getTerrainView(model.terrain)
    featureView = @getFeatureView(model.feature)
    
    container = new createjs.Container()
    container.addChild(terrainView) if terrainView
    container.addChild(featureView) if featureView

    if model.isFirstTile()
      container.x = 0
      container.y = 0
    else
      current =
        x: 0
        y: 0

      for coordinate in model.position.array
        do (coordinate) =>
          [current.x, current.y] = @transformByParity([current.x, current.y], coordinate)
          
      container.x = current.x
      container.y = current.y

    # for each missing neighbor index
    # add an "add neighbor" controller hint
    for index in model.missingNeighborIndices()
      do (index) =>
        # console.log index
        hintView = new createjs.Shape()
        hintView.graphics.beginFill("#EEE").drawCircle(118, 138, 120)
        [hintView.x, hintView.y] = @transformByParity([0, 0], index)
        container.addChild(hintView)

        hintOver = new createjs.Shape()
        hintOver.graphics.beginFill("#AEE").drawCircle(118, 138, 120)
        [hintOver.x, hintOver.y] = @transformByParity([0, 0], index)

        # hintView.onMouseOver = ->
        #   container.addChild(hintOver)
        # hintView.onMouseOut = ->
        #   container.removeChild(hintOver)

        hintView.onClick = ->
          newPosition = model.position.array
          newPosition.push(index)
          MageKnight.bootstrap().addTile(newPosition)

    # nightMatrix = new createjs.ColorMatrix(-5, 1, -35, -82)
    # nightFilter = new createjs.ColorFilter(-5, 1, -35, -82)
    # container.filters = [nightFilter]


    container

  width: 237
  height: 290

  parityChart: 
    0: [1, -1]
    1: [2, 0]
    2: [1, 1]
    3: [-1, 1]
    4: [-2, 0]
    5: [-1, -1]

  transformByParity: (coords, direction) ->
    parity = @parityChart[direction]
    throw "What neighbor is this? #{direction}" unless parity?

    transformedX = coords[0] + @width*parity[0]/2
    transformedY = coords[1] + 2*@height*parity[1]/3

    [transformedX, transformedY]

class TileViewCache
  findByModel: (model) -> TileView.fromModel(model)
    # @_tileViews ?= {}
    # @_tileViews[model.position.array] ?= TileView.fromModel(model)
    # @_tileViews[model.position.array]

MageKnight.TileView = TileView
MageKnight.TileViewCache = TileViewCache