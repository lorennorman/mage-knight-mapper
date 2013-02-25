class TerrainMesh
  constructor: (opts={}) ->
    @tiles = {}
    @groupTiles = []
    @observers = []
    @tileStack = opts['tileStack'] or []

  toObject: ->
    tileObjects = (tile.toObject() for index, tile of @tiles)
    return tiles: tileObjects

  getTileCount: -> (_ @tiles).size()
  revealedTiles: -> tile for location, tile of @tiles
  revealedGroupTiles: -> @groupTiles

  revealableLocations: () ->
    # turn tiles into their adjacencies
    adjacencies = (_ @revealedGroupTiles()).map (tile) ->
      tile.getGroupAdjacencies()
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
    tile.position = hexordinate
    @addTile(tile)

  addTile: (tile) ->
    throw "Tile has no position!" unless tile.position?
    return @addFirstTile(tile) if tile.position.isOrigin()

    hexordinate = tile.position
    # check coordinate for vacancy or throw
    throw "Already a tile at #{hexordinate}" if @tiles[hexordinate.array]?
    # detect all neighbor coordinates, throw if there are none
    neighbors = (neighborHex.array for neighborHex in hexordinate.getAdjacencies())
    neighbors = neighbors.filter (neighbor) => @tiles[neighbor]?
    throw new Error("Failure adding a tile at #{hexordinate}: no neighbors") if neighbors.length is 0

    tile.mesh = this
    @tiles[hexordinate.array] = tile
    @notifyObservers()

  addTileGroup: (centerHexordinate, tileGroup) ->
    (_ tileGroup).each (tile) -> tile.position = centerHexordinate.add(tile.position)

    tryAdding = (group) =>
      retries = []
      (_ group).each (tile) =>
        try
          @addTile(tile)
        catch e
          retries.push(tile)
          # throw e

      if retries.length is group.length
        console.log retries
        throw "Can't add these tiles"
      else if retries.length > 0
        tryAdding(retries)
      else
        @groupTiles.push centerHexordinate

    tryAdding(tileGroup)

  addNextTileGroupAt: (centerHexordinate) ->
    @addTileGroup(centerHexordinate, @nextTileGroup())

  nextTileGroup: ->
    @tileStack.next()

  addObserver: (observer) ->
    @observers.push observer
    @notifyObserver(observer)

  notifyObservers: () ->
    @notifyObserver(observer) for observer in @observers

  notifyObserver: (observer) ->
    observer.notify?() or observer()

TerrainMesh.fromObject = (object) ->
  tiles = (MageKnight.Tile.fromObject(tileObject) for tileObject in object.tiles)
  tileStack = []

  mesh = new TerrainMesh(tileStack: tileStack)
  mesh.addTileGroup new MageKnight.HexCoordinate([]), tiles
  mesh

MageKnight.TerrainMesh = TerrainMesh