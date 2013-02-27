TerrainType =
  grass:
    type: "grass"
    moveScore: 2
  forest:
    type: "forest"
    moveScore: 3
    moveScoreAtNight: 5
  hill:
    type: "hill"
    moveScore: 3
  desert:
    type: "desert"
    moveScore: 5
    moveScoreAtNight: 3
  wasteland:
    type: "wasteland"
    moveScore: 4
  swamp:
    type: "swamp"
    moveScore: 5
  mountain:
    type: "mountain"
    impassable: "true"
  water:
    type: "water"
    impassable: "true"

class Terrain
  constructor: (opts={}) ->
    @type = opts['type'] or throw "Terrain requires a type"
    @moveScore = opts['moveScore'] or Number.POSITIVE_INFINITY
    @moveScoreAtNight = opts['moveScoreAtNight'] or @moveScore
    @impassable = opts['impassable']

  isImpassable: ->
    @impassable?

terrainObjectCache = {}
Terrain.find = (type) ->
  terrainObjectCache[type] ?= do ->
    throw "No Terrain of type #{type} found" unless TerrainType[type]?
    new Terrain(TerrainType[type])


MageKnight.Terrain = Terrain