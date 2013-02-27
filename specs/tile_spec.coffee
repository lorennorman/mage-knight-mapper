describe 'Tile', ->
  describe "serialization/deserialization", ->
    it "serializes to its coordinates, terrain, and feature", ->
      terrain = MageKnight.Terrain.find "grass"
      feature = "keep"
      tile = new MageKnight.Tile(terrain: terrain, feature: feature)
      tile.position = new MageKnight.HexCoordinate([1, 1, 2, 2])

      tileObject = tile.toObject()

      (expect tileObject.terrain).to.be terrain
      (expect tileObject.feature).to.be "keep"
      (expect tileObject.position).to.eql [1, 1, 2, 2]

    it "deserializes from a hexordinate, terrain, and feature", ->
      tileObject =
        terrain: "desert"
        feature: "magetower"
        position: [2, 2, 3, 3]

      tile = MageKnight.Tile.fromObject(tileObject)

      (expect tile.terrain.type).to.be "desert"
      (expect tile.feature).to.be "magetower"
      (expect tile.position.array).to.eql [2, 2, 3, 3]

  it 'knows its terrain', ->
    tile = new MageKnight.Tile("grass")
    (expect tile.terrain).to.be(MageKnight.Terrain.find("grass"))

