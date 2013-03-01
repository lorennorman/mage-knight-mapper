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
  constructor: (opts={}) ->
    @terrain = do ->
      terrain = opts['terrain']
      if terrain?
        if _.isString(terrain)
          MageKnight.Terrain.find(terrain) 
        else
          terrain
      else
        MageKnight.Terrain.find("grass")

    @feature = opts['feature'] or null
    @position = opts['position'] or new MageKnight.HexCoordinate([])
    @firstTile = false
    @mesh = null
    @observers = []

  isFirstTile: ->
    @firstTile

  toObject: ->
    terrain: @terrain
    feature: @feature
    position: @position.array

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
  terrain = MageKnight.Terrain.find(terrainName)
  feature = Feature.find(featureName)

  new Tile(terrain: terrain, feature: feature)

Tile.fromArray = (orderedProperties) ->
  Tile.fromNames(orderedProperties[0], orderedProperties[1])

Tile.fromObject = (tileObject) ->
  tileObject.position = new MageKnight.HexCoordinate(tileObject.position)
  new Tile(tileObject)


class TileStack
  constructor: (@tileGroups=[]) ->

  next: ->
    MageKnight.Tile.fromObject(tileObject) for tileObject in @tileGroups.pop()

  toObject: ->
    @tileGroups

TileStack.Special =
  portalA: 
    [
      { position: [ ], terrain: 'grass', feature: 'portal' }
      { position: [0], terrain: 'forest' }
      { position: [1], terrain: 'grass' }
      { position: [2], terrain: 'water' }
      { position: [3], terrain: 'water' }
      { position: [4], terrain: 'water' }
      { position: [5], terrain: 'grass' }
    ]
  portalB: 
    [
      { position: [ ], terrain: 'grass', feature: 'portal' }
      { position: [0], terrain: 'forest' }
      { position: [1], terrain: 'grass' }
      { position: [2], terrain: 'grass' }
      { position: [3], terrain: 'water' }
      { position: [4], terrain: 'water' }
      { position: [5], terrain: 'grass' }
    ]
  v: 
    [
      { position: [ ], terrain: 'grass', feature: 'volkarescamp' }
      { position: [0], terrain: 'mountain' }
      { position: [1], terrain: 'wasteland', feature: 'draconum' }
      { position: [2], terrain: 'desert', feature: 'village' }
      { position: [3], terrain: 'hill' }
      { position: [4], terrain: 'water' }
      { position: [5], terrain: 'forest', feature: 'orcs' }
    ]

TileStack.Grassland = {}
TileStack.Grassland[1] = 
  [
    { position: [ ], terrain: 'forest', feature: 'glade' }
    { position: [0], terrain: 'water' }
    { position: [1], terrain: 'grass', featre: 'village' }
    { position: [2], terrain: 'grass' }
    { position: [3], terrain: 'grass' }
    { position: [4], terrain: 'forest' }
    { position: [5], terrain: 'forest', feature: 'orcs' }
  ]
TileStack.Grassland[2] = 
  [
    { position: [ ], terrain: 'hill' }
    { position: [0], terrain: 'forest', feature: 'glade' }
    { position: [1], terrain: 'grass', feature: 'village' }
    { position: [2], terrain: 'grass' }
    { position: [3], terrain: 'hill', feature: 'minegreen' }
    { position: [4], terrain: 'grass' }
    { position: [5], terrain: 'hill', feature: 'orcs' }
  ]
TileStack.Grassland[3] = 
  [
    { position: [ ], terrain: 'forest' }
    { position: [0], terrain: 'hill', feature: 'keep' }
    { position: [1], terrain: 'hill' }
    { position: [2], terrain: 'hill', feature: 'minewhite' }
    { position: [3], terrain: 'grass', feature: 'village' }
    { position: [4], terrain: 'grass' }
    { position: [5], terrain: 'grass' }
  ]
TileStack.Grassland[4] = 
  [
    { position: [ ], terrain: 'desert', feature: 'magetower' }
    { position: [0], terrain: 'desert' }
    { position: [1], terrain: 'mountain' }
    { position: [2], terrain: 'grass', feature: 'village' }
    { position: [3], terrain: 'grass' }
    { position: [4], terrain: 'hill', feature: 'orcs' }
    { position: [5], terrain: 'desert' }
  ]
TileStack.Grassland[5] = 
  [
    { position: [ ], terrain: 'water' }
    { position: [0], terrain: 'grass', feature: 'monastery' }
    { position: [1], terrain: 'grass', feature: 'orcs' }
    { position: [2], terrain: 'hill', feature: 'mineblue' }
    { position: [3], terrain: 'forest' }
    { position: [4], terrain: 'forest', feature: 'glade' }
    { position: [5], terrain: 'forest' }
  ]
TileStack.Grassland[6] = 
  [
    { position: [ ], terrain: 'hill', feature: 'minered' }
    { position: [0], terrain: 'forest' }
    { position: [1], terrain: 'grass' }
    { position: [2], terrain: 'forest', feature: 'orcs' }
    { position: [3], terrain: 'hill' }
    { position: [4], terrain: 'hill', feature: 'monsterden' }
    { position: [5], terrain: 'mountain' }
  ]
TileStack.Grassland[7] = 
  [
    { position: [ ], terrain: 'swamp' }
    { position: [0], terrain: 'forest', feature: 'orcs' }
    { position: [1], terrain: 'forest', feature: 'glade' }
    { position: [2], terrain: 'grass', feature: 'dungeon' }
    { position: [3], terrain: 'grass' }
    { position: [4], terrain: 'grass', feature: 'monastery' }
    { position: [5], terrain: 'water' }
  ]
TileStack.Grassland[8] = 
  [
    { position: [ ], terrain: 'swamp', feature: 'orcs' }
    { position: [0], terrain: 'forest', feature: 'ruins' }
    { position: [1], terrain: 'grass' }
    { position: [2], terrain: 'swamp', feature: 'village' }
    { position: [3], terrain: 'swamp' }
    { position: [4], terrain: 'forest' }
    { position: [5], terrain: 'forest', feature: 'glade' }
  ]
TileStack.Grassland[9] = 
  [
    { position: [ ], terrain: 'mountain' }
    { position: [0], terrain: 'mountain' }
    { position: [1], terrain: 'wasteland', feature: 'keep' }
    { position: [2], terrain: 'grass' }
    { position: [3], terrain: 'wasteland', feature: 'magetower' }
    { position: [4], terrain: 'grass' }
    { position: [5], terrain: 'wasteland', feature: 'dungeon' }
  ]
TileStack.Grassland[10] = 
  [
    { position: [ ], terrain: 'mountain' }
    { position: [0], terrain: 'forest' }
    { position: [1], terrain: 'grass' }
    { position: [2], terrain: 'hill', feature: 'ruins' }
    { position: [3], terrain: 'hill', feature: 'keep' }
    { position: [4], terrain: 'hill' }
    { position: [5], terrain: 'hill', feature: 'monsterden' }
  ]
TileStack.Grassland[11] = 
  [
    { position: [ ], terrain: 'grass', feature: 'magetower' }
    { position: [0], terrain: 'water' }
    { position: [1], terrain: 'water' }
    { position: [2], terrain: 'hill', feature: 'orcs' }
    { position: [3], terrain: 'water' }
    { position: [4], terrain: 'grass', feature: 'ruins' }
    { position: [5], terrain: 'hill' }
  ]
TileStack.Grassland[12] = 
  [
    { position: [ ], terrain: 'grass', feature: 'orcs' }
    { position: [0], terrain: 'swamp' }
    { position: [1], terrain: 'hill', feature: 'monastery' }
    { position: [2], terrain: 'mountain' }
    { position: [3], terrain: 'grass', feature: 'maze' }
    { position: [4], terrain: 'hill', feature: 'refugeecamp' }
    { position: [5], terrain: 'mountain' }
  ]
TileStack.Grassland[13] = 
  [
    { position: [ ], terrain: 'forest', feature: 'magetower' }
    { position: [0], terrain: 'hill', feature: 'orcs' }
    { position: [1], terrain: 'water' }
    { position: [2], terrain: 'forest', feature: 'deepminebluegreen' }
    { position: [3], terrain: 'grass' }
    { position: [4], terrain: 'swamp', feature: 'glade' }
    { position: [5], terrain: 'forest' }
  ]
TileStack.Grassland[14] = 
  [
    { position: [ ], terrain: 'grass' }
    { position: [0], terrain: 'grass', feature: 'keep' }
    { position: [1], terrain: 'wasteland', feature: 'maze' }
    { position: [2], terrain: 'hill', feature: 'village' }
    { position: [3], terrain: 'grass' }
    { position: [4], terrain: 'desert', feature: 'deepmineredwhite' }
    { position: [5], terrain: 'desert' }
  ]

TileStack.Core = {}
TileStack.Core.City = {}
TileStack.Core.NonCity = {}
TileStack.Core.NonCity[1] = 
  [
    { position: [ ], terrain: 'desert', feature: 'monastery' }
    { position: [0], terrain: 'desert', feature: 'tomb' }
    { position: [1], terrain: 'desert' }
    { position: [2], terrain: 'desert' }
    { position: [3], terrain: 'hill' }
    { position: [4], terrain: 'hill', feature: 'spawninggrounds' }
    { position: [5], terrain: 'mountain' }
  ]
TileStack.Core.NonCity[2] = 
  [
    { position: [ ], terrain: 'water' }
    { position: [0], terrain: 'swamp', feature: 'ruins' }
    { position: [1], terrain: 'hill', feature: 'minegreen' }
    { position: [2], terrain: 'swamp', feature: 'draconum' }
    { position: [3], terrain: 'swamp', feature: 'magetower' }
    { position: [4], terrain: 'forest' }
    { position: [5], terrain: 'water' }
  ]
TileStack.Core.NonCity[3] = 
  [
    { position: [ ], terrain: 'wasteland' }
    { position: [0], terrain: 'wasteland', feature: 'ruins' }
    { position: [1], terrain: 'hill', feature: 'magetower' }
    { position: [2], terrain: 'wasteland' }
    { position: [3], terrain: 'hill', feature: 'minewhite' }
    { position: [4], terrain: 'wasteland', feature: 'tomb' }
    { position: [5], terrain: 'mountain' }
  ]
TileStack.Core.NonCity[4] = 
  [
    { position: [ ], terrain: 'mountain', feature: 'draconum' }
    { position: [0], terrain: 'hill' }
    { position: [1], terrain: 'wasteland', feature: 'keep' }
    { position: [2], terrain: 'wasteland' }
    { position: [3], terrain: 'wasteland', feature: 'ruins' }
    { position: [4], terrain: 'wasteland' }
    { position: [5], terrain: 'hill', feature: 'mineblue' }
  ]
TileStack.Core.City[5] = 
  [
    { position: [ ], terrain: 'grass', feature: 'citygreen' }
    { position: [0], terrain: 'swamp', feature: 'village' }
    { position: [1], terrain: 'swamp', feature: 'orcs' }
    { position: [2], terrain: 'swamp' }
    { position: [3], terrain: 'forest', feature: 'orcs' }
    { position: [4], terrain: 'water' }
    { position: [5], terrain: 'forest', feature: 'glade' }
  ]
TileStack.Core.City[6] = 
  [
    { position: [ ], terrain: 'grass', feature: 'cityblue' }
    { position: [0], terrain: 'grass', feature: 'monastery' }
    { position: [1], terrain: 'water' }
    { position: [2], terrain: 'water' }
    { position: [3], terrain: 'hill' }
    { position: [4], terrain: 'mountain', feature: 'draconum' }
    { position: [5], terrain: 'forest' }
  ]
TileStack.Core.City[7] = 
  [
    { position: [ ], terrain: 'grass', feature: 'citywhite' }
    { position: [0], terrain: 'grass' }
    { position: [1], terrain: 'forest' }
    { position: [2], terrain: 'water', feature: 'draconum' }
    { position: [3], terrain: 'water' }
    { position: [4], terrain: 'wasteland', feature: 'keep' }
    { position: [5], terrain: 'wasteland', feature: 'spawninggrounds' }
  ]
TileStack.Core.City[8] = 
  [
    { position: [ ], terrain: 'grass', feature: 'cityred' }
    { position: [0], terrain: 'hill', feature: 'minered' }
    { position: [1], terrain: 'desert' }
    { position: [2], terrain: 'desert', feature: 'draconum' }
    { position: [3], terrain: 'wasteland' }
    { position: [4], terrain: 'wasteland', feature: 'draconum' }
    { position: [5], terrain: 'desert', feature: 'ruins' }
  ]
TileStack.Core.City['v'] = TileStack.Special['v']
TileStack.Core.NonCity[9] = 
  [
    { position: [ ], terrain: 'grass', feature: 'draconum' }
    { position: [0], terrain: 'hill', feature: 'magetower' }
    { position: [1], terrain: 'mountain' }
    { position: [2], terrain: 'desert', feature: 'refugeecamp' }
    { position: [3], terrain: 'desert' }
    { position: [4], terrain: 'wasteland' }
    { position: [5], terrain: 'hill', feature: 'labyrinth' }
  ]
TileStack.Core.NonCity[10] = 
  [
    { position: [ ], terrain: 'swamp' }
    { position: [0], terrain: 'water' }
    { position: [1], terrain: 'forest', feature: 'labyrinth' }
    { position: [2], terrain: 'hill', feature: 'orcs' }
    { position: [3], terrain: 'hill', feature: 'orcs' }
    { position: [4], terrain: 'forest', feature: 'keep' }
    { position: [5], terrain: 'swamp', feature: 'deepmineredwhitebluegreen' }
  ]

TileStack.fromObject = (tileStackObject) ->
  new TileStack(tileStackObject)

TileStack.getStartGroup = ->
  new MageKnight.Tile.fromObject(tileObject) for tileObject in TileStack.Special["portalA"]

TileStack.shuffle = (opts={}) ->
  prepareDeck = (sourceDeck, numberOfTiles) ->
    if numberOfTiles is 0
      prepDeck = []
    else
      prepDeck = _.shuffle(tile for index, tile of sourceDeck)
      if numberOfTiles?
        prepDeck = prepDeck.slice(prepDeck.length - numberOfTiles)

    prepDeck

  # shuffle each deck, truncate according to options
  grasslands = prepareDeck(TileStack.Grassland, opts['grasslands'])
  noncity = prepareDeck(TileStack.Core.NonCity, opts['coreNonCity'])
  city = prepareDeck(TileStack.Core.City, opts['coreCity'])

  # shuffle city and non-city core tiles together
  core = _.shuffle noncity.concat(city)

  # place core tiles under grassland tiles, return this final stack
  finalStack = core.concat(grasslands)
  TileStack.fromObject finalStack

MageKnight.TileStack = TileStack
MageKnight.Tile = Tile
MageKnight.Feature = Feature