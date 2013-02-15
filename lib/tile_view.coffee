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
    portal: "portal"
    monastery: "monastery"
    orcs: "orcs"
    village: "village"

  fromModel: (model) ->
    if @terrainFileMap[model.terrain]?
      terrainView = new createjs.Bitmap("terrain/#{@terrainFileMap[model.terrain]}.png")
    else
      terrainView = new createjs.Shape()
      terrainView.graphics.beginFill(@terrainColorMap[model.terrain]).drawCircle(118, 138, 120)

    if @featureFileMap[model.feature]?
      featureView = new createjs.Bitmap("feature/#{@featureFileMap[model.feature]}.png")
      featureView.x = 46
      featureView.y = 56
    else
      featureView = new createjs.Shape()
      featureView.graphics.beginFill(@featureColorMap[model.feature]).drawCircle(115, 137, 40)
    
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

      for coordinate in model.position
        do (coordinate) =>
          [current.x, current.y] = @transformByParity([current.x, current.y], coordinate)
          
      container.x = current.x
      container.y = current.y

      # make dummy tiles where no neighbors are...
      # for each missing neighbor index
      # create a stroked circle view
    hintView = new createjs.Shape()
    hintView.graphics.beginStroke("orange").drawCircle(118, 138, 120)
    [hintView.x, hintView.y] = @transformByParity([0, 0], 1)

    container.addChild(hintView)

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
  findByModel: (model) ->
    @_tileViews ?= {}
    @_tileViews[model.position] ?= TileView.fromModel(model)
    @_tileViews[model.position]

MageKnight.TileView = TileView
MageKnight.TileViewCache = TileViewCache