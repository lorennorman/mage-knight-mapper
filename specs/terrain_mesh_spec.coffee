simpleMesh = ->
  new MageKnight.TerrainMesh tileStack: []

describe 'TerrainMesh', ->
  describe 'serialization', ->
    it 'serializes to an object', ->
      mock1 =
        toObject: -> "mock1"
        position: new MageKnight.HexCoordinate([])
      mock2 =
        toObject: -> "mock2"
        position: new MageKnight.HexCoordinate([0]) 

      mesh = simpleMesh()
      mesh.addTile(mock1)
      mesh.addTile(mock2)

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

    mesh = simpleMesh()
    mesh.addFirstTile(tile)
    (expect tile.firstTile).to.be(true)
    (expect mesh.getOriginTile()).to.be(tile)
 
  it 'adds the first tile just once', ->
    mesh = simpleMesh()
    aft = -> mesh.addFirstTile(new MageKnight.Tile("grass"))
    aft()
    (expect aft).to.throwException()
    (expect mesh.getTileCount()).to.be 1

  it 'adds a tile group as the first tile', ->
    mesh = simpleMesh()
    tile0 = new MageKnight.Tile(terrain: "desert", position: new MageKnight.HexCoordinate([0, 1]))
    tile1 = new MageKnight.Tile(terrain: "grass", position: new MageKnight.HexCoordinate([0]))
    tile2 = new MageKnight.Tile(terrain: "grass", position: new MageKnight.HexCoordinate([]))

    mesh.addTileGroup new MageKnight.HexCoordinate([]), [tile0, tile1, tile2]

    (expect mesh.getTileCount()).to.be 3

  it 'throws if a tilegroup is broken', ->
    mesh = simpleMesh()

    tile0 = new MageKnight.Tile("desert")
    tile0.position = new MageKnight.HexCoordinate([0, 1])

    atg = -> mesh.addTileGroup new MageKnight.HexCoordinate([]), [tile0]
    (expect atg).to.throwException

  it 'recalls a tile by its coordinates', ->
    tile = ["hill"]

    mesh = simpleMesh()
    mesh.addFirstTile({})
    mesh.easyAddTile([1], {})
    mesh.easyAddTile([1, 1], tile)
    
    (expect mesh.getTileAt([1, 1]).terrain).to.be "hill"

  it 'gives access to tiles', ->
    mesh = simpleMesh()
    mesh.addFirstTile({})
    (expect mesh.revealedTiles().length).to.be(1)

  it 'knows the revealable locations at the boundaries'
