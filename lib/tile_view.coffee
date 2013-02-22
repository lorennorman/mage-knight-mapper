Loader =
  filePath: ""

TileView =
  width: 150
  height: 196

  parityChart: 
    0: [1, -1]
    1: [2, 0]
    2: [1, 1]
    3: [-1, 1]
    4: [-2, 0]
    5: [-1, -1]

  terrainFileMap:
    grass: "grass"
    desert: "desert"
    forest: "forest"
    hill: "hill"
    mountain: "mountain"
    water: "water/1"
    swamp: "swamp"
    wasteland: "wasteland"

  featureFileMap:
    portal: "portal"
    village: "village"
    monastery: "monastery"
    glade: "glade"
    minered: "crystalmine_red"
    mineblue: "crystalmine_blue"
    minegreen: "crystalmine_green"
    minewhite: "crystalmine_white"
    orcs: "orcs"
    draconum: "draconom"
    keep: "keep"
    magetower: "magetower"
    ruins: "ruins"
    dungeon: "dungeon"
    tomb: "tomb"
    monsterden: "monsterden"
    spawninggrounds: "spawning1"
    # spawninggrounds2: "spawning2"
    cityred: "city_red"
    cityblue: "city_blue"
    citygreen: "city_green"
    citywhite: "city_white"

  getTerrainView: (terrain) ->
    if @terrainFileMap[terrain]?
      terrainView = new createjs.Bitmap("#{Loader.filePath}terrain/#{@terrainFileMap[terrain]}.png")
    else
      console.log "missing #{terrain} file"
      terrainView = new createjs.Shape()
      terrainView.graphics.beginFill("red").drawCircle(0, 0, 90)

    terrainView

  getFeatureView: (feature) ->
    if @featureFileMap[feature]?
      featureView = new createjs.Bitmap("#{Loader.filePath}feature/#{@featureFileMap[feature]}.png")
    else
      console.log "missing #{feature} file"
      terrainView = new createjs.Shape()
      terrainView.graphics.beginFill("red").drawCircle(0, 0, 90)

    featureView

  fromModel: (model) ->
    container = new createjs.Container()

    [container.x, container.y] = @transformByParity([0, 0], model.position)

    currentTerrainView = null
    currentFeatureView = null

    container.updateByModel = (model) =>
      newTerrainView = @getTerrainView(model.terrain)
      newFeatureView = @getFeatureView(model.feature) if model.feature?

      container.removeChild(currentTerrainView) if currentTerrainView?
      container.addChild(newTerrainView)
      currentTerrainView = newTerrainView

      container.removeChild(currentFeatureView) if currentFeatureView?
      container.addChild(newFeatureView)
      currentFeatureView = newFeatureView

    model.addObserver => container.updateByModel(model)

    container.onClick = (event) ->
      if event.nativeEvent.altKey
        model.cycleFeature()
      else
        model.cycleTerrain()

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
    centerPoint = [TileView.width/2, TileView.height/2]
    hintView.graphics.beginFill("#FFF").drawCircle(0, 0, 60)
    [hintView.x, hintView.y] = TileView.transformByParity(centerPoint, hexordinate)
    
    hintOver = new createjs.Shape()
    hintOver.graphics.beginStroke("green").drawCircle(0, 0, 50)
    [hintOver.x, hintOver.y] = TileView.transformByParity(centerPoint, hexordinate)

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

MageKnight.Loader = Loader
MageKnight.TileView = TileView
MageKnight.HintView = HintView
MageKnight.TileViewCache = TileViewCache