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
    @mesh = null

  isFirstTile: ->
    @firstTile

  neighborAt: (location) ->
    @getNeighbors()[location]

  getNeighbors: () ->
    @mesh.getTileAt(adjacency.array) for adjacency in @position.getAdjacencies()
    
  # addNeighborAt: (location, newNeighbor) ->
  #   if @neighborAt(location)?
  #     throw "Neighbor already exists at #{location}"

  #   @neighbors[location] = newNeighbor



  missingNeighborIndices: () ->
    index for index in [0..5] when not @neighborAt(index)?

Tile.fromNames = (terrainName, featureName) ->
  terrain = Terrain.find(terrainName)
  feature = Feature.find(featureName)

  new Tile(terrain, feature)

Tile.fromArray = (orderedProperties) ->
  Tile.fromNames(orderedProperties[0], orderedProperties[1])

MageKnight.Tile = Tile