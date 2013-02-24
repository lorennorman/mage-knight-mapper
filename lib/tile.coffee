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
  constructor: (opts={}) ->
    @terrain = opts['terrain'] or Terrain.find("grass")
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

  new Tile(terrain: terrain, feature: feature)

Tile.fromArray = (orderedProperties) ->
  Tile.fromNames(orderedProperties[0], orderedProperties[1])

Tile.generateRandom = () ->
  new Tile terrain: Terrain.random()#, Feature.random()]

Tile.fromObject = (tileObject) ->
  tileObject.position = new MageKnight.HexCoordinate(tileObject.position)
  new Tile(tileObject)


tile = (opts) ->
  Tile.fromObject(opts)

TileSet = {}
TileSet.Special =
  portalA: 
    [
      tile position: [ ], terrain: 'grass', feature: 'portal'
      tile position: [0], terrain: 'forest'
      tile position: [1], terrain: 'grass'
      tile position: [2], terrain: 'water'
      tile position: [3], terrain: 'water'
      tile position: [4], terrain: 'water'
      tile position: [5], terrain: 'grass'
    ]
  portalB: 
    [
      tile position: [ ], terrain: 'grass', feature: 'portal'
      tile position: [0], terrain: 'forest'
      tile position: [1], terrain: 'grass'
      tile position: [2], terrain: 'grass'
      tile position: [3], terrain: 'water'
      tile position: [4], terrain: 'water'
      tile position: [5], terrain: 'grass'
    ]
  v: 
    [
      tile position: [ ], terrain: 'grass', feature: 'volkarescamp'
      tile position: [0], terrain: 'mountain'
      tile position: [1], terrain: 'wasteland', feature: 'draconum'
      tile position: [2], terrain: 'desert', feature: 'village'
      tile position: [3], terrain: 'hill'
      tile position: [4], terrain: 'water'
      tile position: [5], terrain: 'forest', feature: 'orcs'
    ]

TileSet.Grassland = {}
TileSet.Grassland[1] = 
  [
    tile position: [ ], terrain: 'forest', feature: 'glade'
    tile position: [0], terrain: 'water'
    tile position: [1], terrain: 'grass', featre: 'village'
    tile position: [2], terrain: 'grass'
    tile position: [3], terrain: 'grass'
    tile position: [4], terrain: 'forest'
    tile position: [5], terrain: 'forest', feature: 'orcs'
  ]
TileSet.Grassland[2] = 
  [
    tile position: [ ], terrain: 'hill'
    tile position: [0], terrain: 'forest', feature: 'glade'
    tile position: [1], terrain: 'grass', feature: 'village'
    tile position: [2], terrain: 'grass'
    tile position: [3], terrain: 'hill', feature: 'minegreen'
    tile position: [4], terrain: 'grass'
    tile position: [5], terrain: 'hill', feature: 'orcs'
  ]
TileSet.Grassland[3] = 
  [
    tile position: [ ], terrain: 'forest'
    tile position: [0], terrain: 'hill', feature: 'keep'
    tile position: [1], terrain: 'hill'
    tile position: [2], terrain: 'hill', feature: 'minewhite'
    tile position: [3], terrain: 'grass', feature: 'village'
    tile position: [4], terrain: 'grass'
    tile position: [5], terrain: 'grass'
  ]
TileSet.Grassland[4] = 
  [
    tile position: [ ], terrain: 'desert', feature: 'magetower'
    tile position: [0], terrain: 'desert'
    tile position: [1], terrain: 'mountain'
    tile position: [2], terrain: 'grass', feature: 'village'
    tile position: [3], terrain: 'grass'
    tile position: [4], terrain: 'hill', feature: 'orcs'
    tile position: [5], terrain: 'desert'
  ]
TileSet.Grassland[5] = 
  [
    tile position: [ ], terrain: 'water'
    tile position: [0], terrain: 'grass', feature: 'monastery'
    tile position: [1], terrain: 'grass', feature: 'orcs'
    tile position: [2], terrain: 'hill', feature: 'mineblue'
    tile position: [3], terrain: 'forest'
    tile position: [4], terrain: 'forest', feature: 'glade'
    tile position: [5], terrain: 'forest'
  ]
TileSet.Grassland[6] = 
  [
    tile position: [ ], terrain: 'hill', feature: 'minered'
    tile position: [0], terrain: 'forest'
    tile position: [1], terrain: 'grass'
    tile position: [2], terrain: 'forest', feature: 'orcs'
    tile position: [3], terrain: 'hill'
    tile position: [4], terrain: 'hill', feature: 'monsterden'
    tile position: [5], terrain: 'mountain'
  ]
TileSet.Grassland[7] = 
  [
    tile position: [ ], terrain: 'swamp'
    tile position: [0], terrain: 'forest', feature: 'orcs'
    tile position: [1], terrain: 'forest', feature: 'glade'
    tile position: [2], terrain: 'grass', feature: 'dungeon'
    tile position: [3], terrain: 'grass'
    tile position: [4], terrain: 'grass', feature: 'monastery'
    tile position: [5], terrain: 'water'
  ]
TileSet.Grassland[8] = 
  [
    tile position: [ ], terrain: 'swamp', feature: 'orcs'
    tile position: [0], terrain: 'forest', feature: 'ruins'
    tile position: [1], terrain: 'grass'
    tile position: [2], terrain: 'swamp', feature: 'village'
    tile position: [3], terrain: 'swamp'
    tile position: [4], terrain: 'forest'
    tile position: [5], terrain: 'forest', feature: 'glade'
  ]
TileSet.Grassland[9] = 
  [
    tile position: [ ], terrain: 'mountain'
    tile position: [0], terrain: 'mountain'
    tile position: [1], terrain: 'wasteland', feature: 'keep'
    tile position: [2], terrain: 'grass'
    tile position: [3], terrain: 'wasteland', feature: 'magetower'
    tile position: [4], terrain: 'grass'
    tile position: [5], terrain: 'wasteland', feature: 'dungeon'
  ]
TileSet.Grassland[10] = 
  [
    tile position: [ ], terrain: 'mountain'
    tile position: [0], terrain: 'forest'
    tile position: [1], terrain: 'grass'
    tile position: [2], terrain: 'hill', feature: 'ruins'
    tile position: [3], terrain: 'hill', feature: 'keep'
    tile position: [4], terrain: 'hill'
    tile position: [5], terrain: 'hill', feature: 'monsterden'
  ]
TileSet.Grassland[11] = 
  [
    tile position: [ ], terrain: 'grass', feature: 'magetower'
    tile position: [0], terrain: 'water'
    tile position: [1], terrain: 'water'
    tile position: [2], terrain: 'hill', feature: 'orcs'
    tile position: [3], terrain: 'water'
    tile position: [4], terrain: 'grass', feature: 'ruins'
    tile position: [5], terrain: 'hill'
  ]
TileSet.Grassland[12] = 
  [
    tile position: [ ], terrain: 'grass', feature: 'orcs'
    tile position: [0], terrain: 'swamp'
    tile position: [1], terrain: 'hill', feature: 'monastery'
    tile position: [2], terrain: 'mountain'
    tile position: [3], terrain: 'grass', feature: 'maze'
    tile position: [4], terrain: 'hill', feature: 'refugeecamp'
    tile position: [5], terrain: 'mountain'
  ]
TileSet.Grassland[13] = 
  [
    tile position: [ ], terrain: 'forest', feature: 'magetower'
    tile position: [0], terrain: 'hill', feature: 'orcs'
    tile position: [1], terrain: 'water'
    tile position: [2], terrain: 'forest', feature: 'deepminegreenblue'
    tile position: [3], terrain: 'grass'
    tile position: [4], terrain: 'swamp', feature: 'glade'
    tile position: [5], terrain: 'forest'
  ]
TileSet.Grassland[14] = 
  [
    tile position: [ ], terrain: 'grass'
    tile position: [0], terrain: 'grass', feature: 'keep'
    tile position: [1], terrain: 'wasteland', feature: 'maze'
    tile position: [2], terrain: 'hill', feature: 'village'
    tile position: [3], terrain: 'grass'
    tile position: [4], terrain: 'desert', feature: 'deepmineredwhite'
    tile position: [5], terrain: 'desert'
  ]

TileSet.Core = {}
TileSet.Core.City = {}
TileSet.Core.NonCity = {}
TileSet.Core.NonCity[1] = 
  [
    tile position: [ ], terrain: 'desert', feature: 'monastery'
    tile position: [0], terrain: 'desert', feature: 'tomb'
    tile position: [1], terrain: 'desert'
    tile position: [2], terrain: 'desert'
    tile position: [3], terrain: 'hill'
    tile position: [4], terrain: 'hill', feature: 'spawninggrounds'
    tile position: [5], terrain: 'mountain'
  ]
TileSet.Core.NonCity[2] = 
  [
    tile position: [ ], terrain: 'water'
    tile position: [0], terrain: 'swamp', feature: 'ruins'
    tile position: [1], terrain: 'hill', feature: 'minegreen'
    tile position: [2], terrain: 'swamp', feature: 'draconum'
    tile position: [3], terrain: 'swamp', feature: 'magetower'
    tile position: [4], terrain: 'forest'
    tile position: [5], terrain: 'water'
  ]
TileSet.Core.NonCity[3] = 
  [
    tile position: [ ], terrain: 'wasteland'
    tile position: [0], terrain: 'wasteland', feature: 'ruins'
    tile position: [1], terrain: 'hill', feature: 'magetower'
    tile position: [2], terrain: 'wasteland'
    tile position: [3], terrain: 'hill', feature: 'minewhite'
    tile position: [4], terrain: 'wasteland', feature: 'tomb'
    tile position: [5], terrain: 'mountain'
  ]
TileSet.Core.NonCity[4] = 
  [
    tile position: [ ], terrain: 'mountain', feature: 'draconum'
    tile position: [0], terrain: 'hill'
    tile position: [1], terrain: 'wasteland', feature: 'keep'
    tile position: [2], terrain: 'wasteland'
    tile position: [3], terrain: 'wasteland', feature: 'ruins'
    tile position: [4], terrain: 'wasteland'
    tile position: [5], terrain: 'hill', feature: 'mineblue'
  ]
TileSet.Core.City[5] = 
  [
    tile position: [ ], terrain: 'grass', feature: 'citygreen'
    tile position: [0], terrain: 'swamp', feature: 'village'
    tile position: [1], terrain: 'swamp', feature: 'orcs'
    tile position: [2], terrain: 'swamp'
    tile position: [3], terrain: 'forest', feature: 'orcs'
    tile position: [4], terrain: 'water'
    tile position: [5], terrain: 'forest', feature: 'glade'
  ]
TileSet.Core.City[6] = 
  [
    tile position: [ ], terrain: 'grass', feature: 'cityblue'
    tile position: [0], terrain: 'grass', feature: 'monastery'
    tile position: [1], terrain: 'water'
    tile position: [2], terrain: 'water'
    tile position: [3], terrain: 'hill'
    tile position: [4], terrain: 'mountain', feature: 'draconum'
    tile position: [5], terrain: 'forest'
  ]
TileSet.Core.City[7] = 
  [
    tile position: [ ], terrain: 'grass', feature: 'citywhite'
    tile position: [0], terrain: 'grass'
    tile position: [1], terrain: 'forest'
    tile position: [2], terrain: 'water', feature: 'draconum'
    tile position: [3], terrain: 'water'
    tile position: [4], terrain: 'wasteland', feature: 'keep'
    tile position: [5], terrain: 'wasteland', feature: 'spawninggrounds'
  ]
TileSet.Core.City[8] = 
  [
    tile position: [ ], terrain: 'grass', feature: 'cityred'
    tile position: [0], terrain: 'hill', feature: 'minered'
    tile position: [1], terrain: 'desert'
    tile position: [2], terrain: 'desert', feature: 'draconum'
    tile position: [3], terrain: 'wasteland'
    tile position: [4], terrain: 'wasteland', feature: 'draconum'
    tile position: [5], terrain: 'desert', feature: 'ruins'
  ]
TileSet.Core.NonCity[9] = 
  [
    tile position: [ ], terrain: 'grass', feature: 'draconum'
    tile position: [0], terrain: 'hill', feature: 'magetower'
    tile position: [1], terrain: 'mountain'
    tile position: [2], terrain: 'desert', feature: 'refugeecamp'
    tile position: [3], terrain: 'desert'
    tile position: [4], terrain: 'wasteland'
    tile position: [5], terrain: 'hill', feature: 'labyrinth'
  ]
TileSet.Core.NonCity[10] = 
  [
    tile position: [ ], terrain: 'swamp'
    tile position: [0], terrain: 'water'
    tile position: [1], terrain: 'forest', feature: 'labyrinth'
    tile position: [2], terrain: 'hill', feature: 'orcs'
    tile position: [3], terrain: 'hill', feature: 'orcs'
    tile position: [4], terrain: 'forest', feature: 'keep'
    tile position: [5], terrain: 'swamp', feature: 'deepmineredwhitebluegreen'
  ]


TileSet.getStartGroup = ->
  TileSet.Special["portalA"]

TileSet.shuffle = (opts={}) ->
  prepareDeck = (sourceDeck, numberOfTiles) ->
    if numberOfTiles is 0
      prepDeck = []
    else
      prepDeck = _.shuffle(tile for index, tile of sourceDeck)
      if numberOfTiles?
        prepDeck = prepDeck.slice(prepDeck.length - numberOfTiles)

    prepDeck

  # shuffle each deck, truncate according to options
  grasslands = prepareDeck(TileSet.Grassland, opts['grasslands'])
  noncity = prepareDeck(TileSet.Core.NonCity, opts['coreNonCity'])
  city = prepareDeck(TileSet.Core.City, opts['coreCity'])

  # shuffle city and non-city core tiles together
  core = _.shuffle noncity.concat(city)

  # place core tiles under grassland tiles, return this final stack
  finalStack = core.concat(grasslands)

MageKnight.TileSet = TileSet
MageKnight.Tile = Tile
MageKnight.Terrain = Terrain
MageKnight.Feature = Feature