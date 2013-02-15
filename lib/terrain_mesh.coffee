class TerrainMesh
  constructor: ->
    @tiles = []
    @observers = []

  addFirstTile: (tile) ->
    throw "Tiles are already started, you must add a Neighbor to and existing tile now" unless @tiles.length == 0

    tile.position = [1, 0, 0]
    @tiles.push tile
    @notifyObservers()

  addNeighborTo: (olderNeighbor, neighborIndex, newNeighbor) ->
    if (neighborIndex.length or 1) > 1
      return @addNeighborTo(olderNeighbor.neighbors[neighborIndex.shift()], neighborIndex, newNeighbor)
    
    neighborIndex = neighborIndex?[0] or neighborIndex

    inverseIndex = (neighborIndex+3)%6

    # try
    throw "Neighbor already exists at #{neighborIndex}" if olderNeighbor.neighbors[neighborIndex]?
    # catch e
    #   # debugger

    olderNeighbor.neighbors[neighborIndex] = newNeighbor
    # newNeighbor.neighbors[inverseIndex] = olderNeighbor

    newNeighbor.neighborTo = olderNeighbor
    newNeighbor.neighborAt = neighborIndex

    @tiles.push(newNeighbor)
    @notifyObservers()


  notifyObservers: () ->
    observer.notify?() or observer() for observer in @observers

MageKnight.TerrainMesh = TerrainMesh