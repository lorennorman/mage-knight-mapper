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
    @firstTile = false

  isFirstTile: ->
    @firstTile

Tile.fromNames = (terrainName, featureName) ->
  terrain = Terrain.find(terrainName)
  feature = Feature.find(featureName)

  new Tile(terrain, feature)

Tile.fromArray = (orderedProperties) ->
  Tile.fromNames(orderedProperties[0], orderedProperties[1])

MageKnight.Tile = Tile