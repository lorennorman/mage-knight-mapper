describe 'Tile', ->
  describe "serialization/deserialization", ->
    it "serializes to its coordinates, terrain, and feature", ->
      terrain = "grass"
      feature = "keep"
      tile = new MageKnight.Tile(terrain: terrain, feature: feature)
      tile.position = new MageKnight.HexCoordinate([1, 1, 2, 2])

      tileObject = tile.toObject()

      (expect tileObject.terrain).to.be "grass"
      (expect tileObject.feature).to.be "keep"
      (expect tileObject.position).to.eql [1, 1, 2, 2]

    it "deserializes from a hexordinate, terrain, and feature", ->
      tileObject =
        terrain: "desert"
        feature: "magetower"
        position: [2, 2, 3, 3]

      tile = MageKnight.Tile.fromObject(tileObject)

      (expect tile.terrain).to.be "desert"
      (expect tile.feature).to.be "magetower"
      (expect tile.position.array).to.eql [2, 2, 3, 3]

  it 'knows its terrain', ->
    tile = new MageKnight.Tile("grass")
    (expect tile.terrain).to.be("grass")

  it 'can cycle through terrain', ->
    tile = new MageKnight.Tile("grass")
    tile.cycleTerrain()
    (expect tile.terrain).to.be("forest")
    tile.cycleTerrain()
    (expect tile.terrain).to.be("hill")

  it 'wraps around at the end of the terrain list', ->
    tile = new MageKnight.Tile(terrain: "water")
    tile.cycleTerrain()
    (expect tile.terrain).to.be("grass")

  it 'can cycle through features', ->
    tile = new MageKnight.Tile(terrain: "grass")
    tile.cycleFeature()
    (expect tile.feature).to.be("village")
    tile.cycleFeature()
    (expect tile.feature).to.be("glade")

  it 'wraps at the end of the list', ->
    tile = new MageKnight.Tile(terrain: "grass", feature: "citywhite")
    tile.cycleFeature()
    (expect tile.feature).to.be(null)
    