class TerrainMesh
  constructor: ->
    @tiles = {}
    @observers = []

  revealedTiles: () ->
    tile for location, tile of @tiles

  revealableLocations: () ->
    # turn tiles into their adjacencies
    adjacencies = @revealedTiles().map (tile) -> tile.position.getAdjacencies()

    # concatenate them all together
    adjacencies = adjacencies.reduce (acc, adjs) ->
      acc.concat(adjs)
    , []

    # drop all the locations where a tile already is
    adjacencies = adjacencies.filter (adj) => not @tiles[adj.array]?

    # de-duple this array
    # TODO

  addFirstTile: (tile) ->
    throw "Tiles are already started, you can only add tiles at hex coordinates from origin now" if @_originTile?

    coordinates = new MageKnight.HexCoordinate([])
    tile.position = coordinates
    tile.firstTile = true
    tile.mesh = this

    @tiles[coordinates.array] = tile
    @_originTile = tile

    @notifyObservers()

  getOriginTile: -> @_originTile

  getTileAt: (hexordinateLiteral) ->
    @tiles[MageKnight.HexCoordinate.validate(hexordinateLiteral)]

  addTile: (hexordinateLiteral, tileProperties=["grass"]) ->
    hexordinate = new MageKnight.HexCoordinate(hexordinateLiteral)
    newTile = MageKnight.Tile.fromArray(tileProperties)
    newTile.position = hexordinate
    newTile.mesh = this

    # check coordinate for vacancy or throw
    throw "Already a tile at #{hexordinate}" if @tiles[hexordinate.array]?
    # detect all neighbor coordinates, throw if there are none
    neighbors = []
    for neighborHex in hexordinate.getAdjacencies()
      do (neighborHex) ->
        neighbors.push neighborHex.array 

    neighbors = neighbors.filter (neighbor) => @tiles[neighbor]?
    throw "Failure adding a tile at #{hexordinate}: no neighbors" if neighbors.length is 0
    # add to neighbor relationship mesh
    # @reciprocateNeighbors(neighbor, newTile) for neighbor in neighbors

    @tiles[hexordinate.array] = newTile
    @notifyObservers()

  # reciprocateNeighbors: (neighborA, neighborB) ->
  #   neighborA.addNeighborAt(neighborIndex, newTile)
  #   newTile.addNeighborAt((neighborIndex+3)%6, parentTile)

  notifyObservers: () ->
    observer.notify?() or observer() for observer in @observers

MageKnight.TerrainMesh = TerrainMesh