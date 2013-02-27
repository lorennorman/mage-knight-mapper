describe "Terrain", ->
  it "can be looked up by string", ->
    grass = MageKnight.Terrain.find("grass")
    (expect grass.type).to.be "grass"

  it "caches terrain objects", ->
    desert1 = MageKnight.Terrain.find("desert")
    desert2 = MageKnight.Terrain.find("desert")
    (expect desert1).to.be desert2

  describe 'movement', ->
    subject = -> new MageKnight.Terrain(type: 'road', moveScore: 1)

    it "knows its move score", -> (expect subject().moveScore).to.be 1

    it "is the same by day and night", ->
      (expect subject().moveScore).to.be subject().moveScoreAtNight

  describe "impassable terrain", ->
    subject = -> new MageKnight.Terrain(type: "everest", impassable: true)

    it "is impassable", ->
      (expect subject().isImpassable()).to.be true

    it "has infinite movement", ->
      (expect subject().moveScore).to.be Number.POSITIVE_INFINITY

  describe "night movement", ->
    subject = -> new MageKnight.Terrain(type: "alleyways", moveScore: 2, moveScoreAtNight: 8)

    it "knows its daytime move score", ->
      (expect subject().moveScore).to.be 2

    it "knows its nighttime move score", ->
      (expect subject().moveScoreAtNight).to.be 8