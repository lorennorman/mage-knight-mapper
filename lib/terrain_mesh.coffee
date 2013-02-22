class TerrainMesh
  constructor: ->
    @tiles = {}
    @observers = []

  toObject: ->
    tileObjects = (tile.toObject() for index, tile of @tiles)
    return tiles: tileObjects

  revealedTiles: () -> tile for location, tile of @tiles

  revealableLocations: () ->
    # turn tiles into their adjacencies
    adjacencies = @revealedTiles().map (tile) -> tile.position.getAdjacencies()
    # concatenate them all together
    adjacencies = adjacencies.reduce (acc, adjs) ->
      acc.concat(adjs)
    , []
    # drop all the locations where a tile already is
    adjacencies = adjacencies.filter (adj) => not @tiles[adj.array]?
    # de-dupe this array
    # TODO

  addFirstTile: (tile) ->
    if @_originTile?
      throw "Tiles are already started, you can only add tiles at hex coordinates from origin now"

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

  easyAddTile: (hexordinateLiteral, tileProperties=["grass"]) ->
    hexordinate = new MageKnight.HexCoordinate(hexordinateLiteral)
    tile = MageKnight.Tile.fromArray(tileProperties)
    @addTile(hexordinate, tile)

  addTile: (hexordinate, tile) ->
    return @addFirstTile(tile) if not @getOriginTile() and hexordinate.isOrigin()

    tile.position = hexordinate
    tile.mesh = this

    # check coordinate for vacancy or throw
    throw "Already a tile at #{hexordinate}" if @tiles[hexordinate.array]?
    # detect all neighbor coordinates, throw if there are none
    neighbors = []
    for neighborHex in hexordinate.getAdjacencies()
      do (neighborHex) ->
        neighbors.push neighborHex.array 

    neighbors = neighbors.filter (neighbor) => @tiles[neighbor]?
    throw new Error("Failure adding a tile at #{hexordinate}: no neighbors") if neighbors.length is 0

    @tiles[hexordinate.array] = tile
    @notifyObservers()

  addObserver: (observer) ->
    @observers.push observer
    @notifyObserver(observer)

  notifyObservers: () ->
    @notifyObserver(observer) for observer in @observers

  notifyObserver: (observer) ->
    observer.notify?() or observer()

TerrainMesh.fromObject = (object) ->
  mesh = new TerrainMesh()

  tileObjects = (_ object.tiles).sortBy (tile) -> tile.position.length
  tiles = (MageKnight.Tile.fromObject(tileObject) for tileObject in tileObjects)
  tiles = (_ tiles).sortBy (tile) -> tile.position.array.length

  firstTile = tiles.shift()
  throw "Why isn't the first tile an origin tile?" unless firstTile.position.isOrigin()

  mesh.addFirstTile(firstTile)

  for tile in tiles
    do (tile) ->    
      mesh.addTile(tile.position, tile)

  mesh

MageKnight.TerrainMesh = TerrainMesh