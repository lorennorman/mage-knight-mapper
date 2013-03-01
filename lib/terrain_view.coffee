TerrainFiles =
  locateFile: (terrainType) ->
    "#{MageKnight.Loader.filePath}terrain/#{this[terrainType]}.png"

  grass: "grass"
  desert: "desert"
  forest: "forest"
  hill: "hill"
  mountain: "mountain"
  water: "water/1"
  swamp: "swamp"
  wasteland: "wasteland"

AnimatedTerrainFiles =
  locateFile: (terrainType) ->
    fileName = this[terrainType]
    if fileName? then "#{MageKnight.Loader.filePath}terrain/#{fileName}.png" else null

  water: "water_animation"

TerrainView =
  create: (terrain) ->
    terrainFile = TerrainFiles.locateFile(terrain.type)
    throw "No terrain file in dictionary for:" + terrain unless terrainFile?
    baseTerrain = new createjs.Bitmap(terrainFile)

    animationFile = AnimatedTerrainFiles.locateFile(terrain.type)

    if animationFile?
      AnimatedTerrainView.create(baseTerrain, animationFile)
    else
      baseTerrain

AnimatedTerrainView =
  create: (baseTerrain, animationFile) ->
    container = new createjs.Container

    spriteSheet = new createjs.SpriteSheet
      images: [ animationFile ]
      frames:
        width:  MageKnight.TileView.width
        height: MageKnight.TileView.height - 8
        count:  38
      animations:
        run:  [ 1, 38 ]

    animation = new createjs.BitmapAnimation(spriteSheet)

    play = -> animation.play()
    rewind = -> animation.gotoAndStop("run")

    animateCycle = ->
      play()
      setTimeout ->
        rewind()
        setTimeout ->
          animateCycle()
        , 10000
      , 2400

    animateCycle()

    container.addChild baseTerrain, animation
    container


MageKnight.TerrainView = TerrainView