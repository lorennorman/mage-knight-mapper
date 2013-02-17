describe 'TerrainMesh', ->
  it 'recalls its first tile', ->
    tile =
      firstTile: false

    mesh = new MageKnight.TerrainMesh
    mesh.addFirstTile(tile)
    (expect tile.firstTile).to.be(true)
    (expect mesh.getOriginTile()).to.be(tile)
 
  it 'adds the first tile just once', ->
    mesh = new MageKnight.TerrainMesh
    addTile = -> mesh.addFirstTile(["grass"])
    addTile()
    (expect addTile).to.throwException()

  it 'recalls a tile by its coordinates', ->
    tile = ["hill"]

    mesh = new MageKnight.TerrainMesh
    mesh.addFirstTile({})
    mesh.addTile([1], {})
    mesh.addTile([1, 1], tile)
    
    (expect mesh.getTileAt([1, 1]).terrain).to.be "hill"

  it 'gives access to tiles', ->
    mesh = new MageKnight.TerrainMesh
    mesh.addFirstTile({})
    (expect mesh.revealedTiles().length).to.be(1)

  it 'lists valid revealable locations', ->
    mesh = new MageKnight.TerrainMesh
    mesh.addFirstTile({})
    (expect mesh.revealableLocations().length).to.be(6)
    mesh.addTile([1], {})
    (expect mesh.revealableLocations().length).to.be(10)
