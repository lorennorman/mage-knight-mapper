class TerrainMesh
  constructor: ->
    @tiles = []
    @observers = []

  addFirstTile: (tile) ->
    throw "Tiles are already started, you can only add tiles at hex coordinates from origin now" unless @tiles.length == 0

    tile.firstTile = true

    @tiles.push tile
    @notifyObservers()

  getOriginTile: -> @tiles[0]

  getTileAtCoordinates: (hexCoordinates) ->
    currentTile = @getOriginTile()

    while hexCoordinates.length > 1
      currentTile = currentTile.neighbors[hexCoordinates.shift()]

    finalCoordinate = (hexCoordinates?[0] or hexCoordinates)

    [currentTile, finalCoordinate]

  addTile: (hexCoordinates, tileProperties=["grass"]) ->
    newTile = MageKnight.Tile.fromArray(tileProperties)
    newTile.position = hexCoordinates.slice(0)

    [parentTile, neighborIndex] = @getTileAtCoordinates(hexCoordinates)

    if parentTile.neighbors[neighborIndex]?
      throw "Neighbor already exists at #{neighborIndex}"

    parentTile.neighbors[neighborIndex] = newTile
    newTile.neighbors[(neighborIndex+3)%6] = parentTile

    @tiles.push(newTile)
    @notifyObservers()


  notifyObservers: () ->
    observer.notify?() or observer() for observer in @observers

MageKnight.TerrainMesh = TerrainMesh