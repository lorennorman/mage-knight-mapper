describe 'TerrainMesh', ->
  describe 'serialization', ->
    it 'serializes to an object', ->
      mock1 =
        toObject: -> "mock1"
      mock2 =
        toObject: -> "mock2"

      mesh = new MageKnight.TerrainMesh()
      mesh.addTile(new MageKnight.HexCoordinate([]), mock1)
      mesh.addTile(new MageKnight.HexCoordinate([0]), mock2)

      meshObject = mesh.toObject()

      (expect meshObject.tiles).to.contain("mock1")
      (expect meshObject.tiles).to.contain("mock2")

    it 'deserializes from an object', ->
      terrainMeshObject =
        tiles: [
          terrain: "grass"
          feature: "keep"
          position: []
        , 
          terrain: "desert"
          position: [0]
        ]

      mesh = MageKnight.TerrainMesh.fromObject(terrainMeshObject)

      console.log mesh.tiles
      (expect mesh.getOriginTile().feature).to.be "keep"
      (expect mesh.getTileAt([0]).terrain).to.be "desert"

  it 'recalls its first tile', ->
    tile =
      firstTile: false

    mesh = new MageKnight.TerrainMesh
    mesh.addFirstTile(tile)
    (expect tile.firstTile).to.be(true)
    (expect mesh.getOriginTile()).to.be(tile)
 
  it 'adds the first tile just once', ->
    mesh = new MageKnight.TerrainMesh
    addTile = -> mesh.addFirstTile(new MageKnight.Tile("grass"))
    addTile()
    (expect addTile).to.throwException()

  it 'recalls a tile by its coordinates', ->
    tile = ["hill"]

    mesh = new MageKnight.TerrainMesh
    mesh.addFirstTile({})
    mesh.easyAddTile([1], {})
    mesh.easyAddTile([1, 1], tile)
    
    (expect mesh.getTileAt([1, 1]).terrain).to.be "hill"

  it 'gives access to tiles', ->
    mesh = new MageKnight.TerrainMesh
    mesh.addFirstTile({})
    (expect mesh.revealedTiles().length).to.be(1)

  it 'lists valid revealable locations', ->
    mesh = new MageKnight.TerrainMesh
    mesh.addFirstTile({})
    (expect mesh.revealableLocations().length).to.be(6)
    mesh.easyAddTile([1], {})
    (expect mesh.revealableLocations().length).to.be(10)
