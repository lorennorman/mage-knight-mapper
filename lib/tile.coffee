Terrain =
  find: (name) ->
    name

Feature =
  find: (name) ->
    name 

class Tile
  constructor: (@terrain, @feature) ->
    @position = []
    @neighbors = []

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

  getTileView: ->
    @_tileView ?= do =>
      if @terrainFileMap[@terrain]?
        terrainView = new createjs.Bitmap("terrain/#{@terrainFileMap[@terrain]}.png")
      else
        terrainView = new createjs.Shape()
        terrainView.graphics.beginFill(@terrainColorMap[@terrain]).drawCircle(118, 138, 120)

      if @featureFileMap[@feature]?
        featureView = new createjs.Bitmap("feature/#{@featureFileMap[@feature]}.png")
        featureView.x = 46
        featureView.y = 56
      else
        featureView = new createjs.Shape()
        featureView.graphics.beginFill(@featureColorMap[@feature]).drawCircle(115, 137, 40)
      
      container = new createjs.Container()
      container.addChild(terrainView) if terrainView
      container.addChild(featureView) if featureView

      width = 237
      height = 290

      if @position[1] is 0 and @position[2] is 0
        container.x = 0
        container.y = 0
      else
        sourceTile = @neighborTo.getTileView()
        index = (@neighborAt+3) % 6
        parityChart = 
          0: [-1, 1]
          1: [-2, 0]
          2: [-1, -1]
          3: [1, -1]
          4: [2, 0]
          5: [1, 1]
        parity = parityChart[index]
        throw "What neighbor is this? #{index}" unless parity?

        container.x = sourceTile.x + width*parity[0]/2
        container.y = sourceTile.y + 2*height*parity[1]/3

      container

Tile.fromNames = (terrainName, featureName) ->
  terrain = Terrain.find(terrainName)
  feature = Feature.find(featureName)

  new Tile(terrain, feature)

MageKnight.Tile = Tile