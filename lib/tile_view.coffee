TileView =
  width: 150
  height: 188

  parityChart: 
    0: [1, -1]
    1: [2, 0]
    2: [1, 1]
    3: [-1, 1]
    4: [-2, 0]
    5: [-1, -1]

  terrainColorMap:
    grass: "green"
    desert: "yellow"
    mountain: "darkblue"
    wasteland: "#444"
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
    wasteland: "wasteland"

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
    glade: "glade"
    magetower: "magetower"
    village: "village"
    ruins: "ruins"
    dungeon: "dungeon"
    mine: "crystalmine"
    draconum: "draconom"
    monsterden: "monsterden"
    spawninggrounds: "spawning1"
    tomb: "tomb"

  getTerrainView: (terrain) ->
    if @terrainFileMap[terrain]?
      terrainView = new createjs.Bitmap("terrain/#{@terrainFileMap[terrain]}.png")

      unless terrain is "grass" or terrain is "hill" or terrain is "wasteland"
        terrainView.scaleX = .64
        terrainView.scaleY = .7
    else
      terrainView = new createjs.Shape()
      terrainView.graphics.beginFill(@terrainColorMap[terrain]).drawCircle(118, 138, 120)

    terrainView

  getFeatureView: (feature) ->
    if @featureFileMap[feature]?
      featureView = new createjs.Bitmap("feature/#{@featureFileMap[feature]}.png")

    else
      featureView = new createjs.Shape()
      featureView.graphics.beginFill(@featureColorMap[feature]).drawCircle(115, 137, 40)

    featureView

  fromModel: (model) ->
    container = new createjs.Container()

    [container.x, container.y] = @transformByParity([0, 0], model.position)

    currentTerrainView = null
    currentFeatureView = null

    container.updateByModel = (model) =>
      newTerrainView = @getTerrainView(model.terrain)
      newFeatureView = @getFeatureView(model.feature)

      container.removeChild(currentTerrainView) if currentTerrainView?
      container.addChild(newTerrainView)
      currentTerrainView = newTerrainView

      container.removeChild(currentFeatureView) if currentFeatureView?
      container.addChild(newFeatureView)
      currentFeatureView = newFeatureView

    model.addObserver => container.updateByModel(model)

    container

  getNightFilter: ->
    throw "You must have the external Filters included!" unless createjs.ColorMatrix and createjs.ColorMatrixFilter

    brightness = -5
    contrast = 0
    saturation = -35
    hue = -82
    colorMatrix = new createjs.ColorMatrix(brightness, contrast, saturation, hue)
    colorMatrixFilter = new createjs.ColorMatrixFilter(colorMatrix)    

  transformByParity: (coordinate, hexordinates) ->
    transformedX = coordinate[0]
    transformedY = coordinate[1]

    for hexordinate in hexordinates.array
      do (hexordinate) =>
        parity = @parityChart[hexordinate]
        throw "What neighbor is this? #{direction}" unless parity?

        transformedX += @width*parity[0]/2
        transformedY += 2*@height*parity[1]/3

    [transformedX, transformedY]

HintView =
  fromHexordinate: (hexordinate) ->
    hintView = new createjs.Shape()
    hintView.graphics.beginFill("#FFF").drawCircle(78, 104, 50)
    [hintView.x, hintView.y] = TileView.transformByParity([0, 0], hexordinate)
    
    hintOver = new createjs.Shape()
    hintOver.graphics.beginStroke("green").drawCircle(78, 104, 50)
    [hintOver.x, hintOver.y] = TileView.transformByParity([0, 0], hexordinate)

    container = new createjs.Container()
    container.addChild(hintView)

    container.onMouseOver = ->
      container.addChild(hintOver)

    container.onMouseOut = ->
      container.removeChild(hintOver)

    container

class TileViewCache
  findByModel: (model) ->
    @_tileViews ?= {}
    @_tileViews[model.position.array] ?= TileView.fromModel(model)
    @_tileViews[model.position.array]

MageKnight.TileView = TileView
MageKnight.HintView = HintView
MageKnight.TileViewCache = TileViewCache