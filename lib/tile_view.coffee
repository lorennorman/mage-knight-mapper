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
    # x-pack features
    deepmineredwhite: "redwhitedeepmine"
    deepminebluegreen: "greenbluedeepmine"
    deepmineredwhitebluegreen: "4waydeepmine"
    maze: "maze"
    labyrinth: "labyrinth"
    refugeecamp: "camp"
    volkarescamp: "generalcamp"

  getFeatureView: (feature) ->
    if @featureFileMap[feature]?
      featureView = new createjs.Bitmap("#{Loader.filePath}feature/#{@featureFileMap[feature]}.png")
    else
      console.log "missing #{feature} file"
      terrainView = new createjs.Shape()
      terrainView.graphics.beginFill("red").drawCircle(0, 0, 90)

    featureView

  getMoveScoreOverlay: (terrain) ->
    unless terrain.impassable
      moveScoreText = new createjs.Text(terrain.moveScore, "150px Roboto") 
      moveScoreText.alpha = .5
      moveScoreText.x = 30
      # moveScoreText.y = 10

    moveScoreText

  fromModel: (model) ->
    container = new createjs.Container()

    [container.x, container.y] = @transformByParity([0, 0], model.position)

    currentTerrainView = null
    currentFeatureView = null
    currentMoveScoreOverlay = null

    container.updateByModel = (model) =>
      newTerrainView = MageKnight.TerrainView.create(model.terrain)
      newFeatureView = @getFeatureView(model.feature) if model.feature?

      container.removeChild(currentTerrainView) if currentTerrainView?
      container.addChild(newTerrainView)
      currentTerrainView = newTerrainView

      container.removeChild(currentFeatureView) if currentFeatureView?
      container.addChild(newFeatureView)
      currentFeatureView = newFeatureView

      if MageKnight.ViewSettings.showMoveScore
        currentMoveScoreOverlay = @getMoveScoreOverlay(model.terrain)
        container.addChild(currentMoveScoreOverlay)
      else
        container.removeChild(currentMoveScoreOverlay) if currentMoveScoreOverlay?

    model.addObserver => container.updateByModel(model)

    # fade in the tiles
    container.alpha = 0
    setTimeout ->
      createjs.Tween.get(container).to({alpha: 1}, 5000, createjs.Ease.quintOut)

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
    hintView = new createjs.Bitmap("#{MageKnight.Loader.filePath}interface/7hex.png")
    centerPoint = [-TileView.width, -TileView.height*2/3]
    hintView.alpha = .25
    [hintView.x, hintView.y] = TileView.transformByParity(centerPoint, hexordinate)

    hintView.onMouseOver = ->
      createjs.Tween.get(hintView).to({alpha: .7}, 500, createjs.Ease.quartOut)

    hintView.onMouseOut = ->
      createjs.Tween.get(hintView, override: true).to({alpha: .25}, 300, createjs.Ease.quartOut)

    hintView

class TileViewCache
  findByModel: (model) ->
    @_tileViews ?= {}
    @_tileViews[model.position.array] ?= TileView.fromModel(model)
    @_tileViews[model.position.array]

MageKnight.Loader = Loader
MageKnight.TileView = TileView
MageKnight.HintView = HintView
MageKnight.TileViewCache = TileViewCache