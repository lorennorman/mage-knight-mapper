describe "TerrainMeshView", ->
  it "adds itself as an observer to the given model", ->
    mock =
      called: false
      addObserver: () -> @called = true

    new MageKnight.TerrainMeshView(mock)
    (expect mock.called).to.be(true)
