hex = (array) ->
  new MageKnight.HexCoordinate(array)

describe 'HexCoordinates', ->
  it "has basic equality", ->
    hc = hex([1, 1])
    (expect hc).to.eql hex([1, 1])
    (expect hc).not.to.eql hex([2, 2])

  describe "inefficient path validation", ->
    it "throws for invalid elements", ->
      (expect -> hex([0, 1, 6]) ).to.throwException (e) ->
        expect(e).to.be.a(MageKnight.HexCoordinate.ValidationError)

    it "sorts the path", ->
      hc = hex([1, 2, 1, 2])
      (expect hc.array).to.eql [1, 1, 2, 2]

    it "eliminates triples", ->
      hc = hex([1, 3, 4, 5])
      (expect hc.array).to.eql [4]

      hc2 = hex([1, 1, 3, 3, 5, 5])
      (expect hc2.array).to.eql []

    it "eliminates opposites", ->
      hc = hex([0, 0, 3, 3, 3])
      (expect hc.array).to.eql [3]

    it "collapses nearbys", ->
      hc = hex([0, 2])
      (expect hc.array).to.eql [1]

  it 'has 6 adjacencies', ->
    # not sure how to test for the present of certain coordinates...
    adjacencies = hex([1, 1]).getAdjacencies()
    (expect adjacencies.length).to.be(6)

    adjacencies = hex([1]).getAdjacencies()
    (expect adjacencies.length).to.be(6)
