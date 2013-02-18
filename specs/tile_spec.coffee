describe 'Tile', ->
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
    tile = new MageKnight.Tile("water")
    tile.cycleTerrain()
    (expect tile.terrain).to.be("grass")

  it 'can cycle through features', ->
    tile = new MageKnight.Tile("grass")
    tile.cycleFeature()
    (expect tile.feature).to.be("orcs")
    tile.cycleFeature()
    (expect tile.feature).to.be("village")

  it 'wraps at the end of the list', ->
    tile = new MageKnight.Tile("grass", "city")
    tile.cycleFeature()
    (expect tile.feature).to.be(null)
    