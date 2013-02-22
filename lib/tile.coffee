Terrain =
  types: [
    "grass", "forest", "hill", "mountain",
    "desert", "swamp", "wasteland", "water"
  ]

  next: (type) ->
    nextIndex = @types.indexOf(type)+1
    nextIndex = nextIndex % @types.length
    @types[nextIndex]

  find: (name) ->
    name

  random: () ->
    @types[Math.floor(Math.random()*@types.length)]

Feature =
  types: [
    null, "village", "glade", "monastery",
    "minegreen", "minered", "mineblue", "minewhite",
    "orcs", "draconum",
    "keep", "magetower",
    "ruins", "dungeon", "tomb", "monsterden", "spawninggrounds",
    "cityblue", "cityred", "citygreen", "citywhite"
  ]

  next: (type) ->
    nextIndex = @types.indexOf(type)+1
    nextIndex = nextIndex % @types.length
    @types[nextIndex]

  find: (name) ->
    name 

  random: () ->
    @types[Math.floor(Math.random()*@types.length)]

class Tile
  constructor: (@terrain, @feature=null) ->
    @position = []
    @firstTile = false
    @mesh = null
    @observers = []

  isFirstTile: ->
    @firstTile

  toObject: ->
    terrain: @terrain
    feature: @feature
    position: @position.array

  cycleTerrain: () ->
    @terrain = Terrain.next(@terrain)
    @notifyObservers()

  cycleFeature: () ->
    @feature = Feature.next(@feature)
    @notifyObservers()

  neighborAt: (location) ->
    @getNeighbors()[location]

  getNeighbors: () ->
    @mesh.getTileAt(adjacency.array) for adjacency in @position.getAdjacencies()
    
  missingNeighborIndices: () ->
    index for index in [0..5] when not @neighborAt(index)?

  addObserver: (observer) ->
    @observers.push observer
    @notifyObserver(observer)

  notifyObservers: () ->
    @notifyObserver(observer) for observer in @observers

  notifyObserver: (observer) ->
    observer.notify?(this) or observer(this)


Tile.fromNames = (terrainName, featureName=null) ->
  terrain = Terrain.find(terrainName)
  feature = Feature.find(featureName)

  new Tile(terrain, feature)

Tile.fromArray = (orderedProperties) ->
  Tile.fromNames(orderedProperties[0], orderedProperties[1])

Tile.generateRandom = () ->
  new Tile Terrain.random()#, Feature.random()]

Tile.fromObject = (tileObject) ->
  tile = new Tile(tileObject.terrain, tileObject.feature)
  tile.position = new MageKnight.HexCoordinate(tileObject.position)
  tile

MageKnight.Tile = Tile
MageKnight.Terrain = Terrain
MageKnight.Feature = Feature